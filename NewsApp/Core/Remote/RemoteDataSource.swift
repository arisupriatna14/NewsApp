//
//  RemoteDataSource.swift
//  NewsApp
//
//  Created by Ari Supriatna on 15/10/21.
//

import Foundation
import Alamofire
import NewsKit
import SwiftUI

protocol RemoteDataSourceProtocol: AnyObject {
  func searchNews(by query: String) async -> [NKNews]
  func fetchNewsTopHeadline(by country: NKCountryCode) async -> [NKNews]
}

final class RemoteDataSource: NSObject {
  private override init() { }
  
  static let sharedInstance = RemoteDataSource()
  
  private func afRequest(url: URL) async throws -> Data {
    try await withUnsafeThrowingContinuation { continuation in
      AF.request(url, method: .get)
        .validate()
        .responseData { response in
          if let data = response.data {
            continuation.resume(returning: data)
            return
          }
          
          if let error = response.error {
            continuation.resume(throwing: error)
            return
          }
          
          fatalError("Error while doing Alamofire url request")
        }
    }
  }
}

extension RemoteDataSource: RemoteDataSourceProtocol {
  func searchNews(by query: String) async -> [NKNews] {
    let url = URL(string: "\(NKNewsEndpoint.Get.search(query: query).url)\(NewsKit.apiKey)")!
    var listOfNews: [NKNews] = []
    
    do {
      let response = try await afRequest(url: url)
      let decodedData = try JSONDecoder().decode(NKNewsResponse.self, from: response)
      
      listOfNews = decodedData.articles
    } catch {
      print(error.localizedDescription)
    }
    
    return listOfNews
  }
  
  func fetchNewsTopHeadline(by country: NKCountryCode) async -> [NKNews] {
    let url = URL(string: "\(NKNewsEndpoint.Get.topHeadline(country: country).url)\(NewsKit.apiKey)")!
    var lisftOfNews: [NKNews] = []
    
    do {
      let response = try await afRequest(url: url)
      let decodedData = try JSONDecoder().decode(NKNewsResponse.self, from: response)
      
      lisftOfNews = decodedData.articles
    } catch {
      print(error.localizedDescription)
    }
    
    return lisftOfNews
  }
}

protocol RepositoryProtocol {
  func searchNews(by query: String) async -> [NKNewsModel]
  func getNewsTopHeadline(by country: NKCountryCode) async -> [NKNewsModel]
}

final class Repository: NSObject {
  typealias RepositoryInstance = (RemoteDataSource) -> Repository
  
  fileprivate let remote: RemoteDataSource
  
  private init(remote: RemoteDataSource) {
    self.remote = remote
  }
  
  static let sharedInstance: RepositoryInstance = { remote in
    return Repository(remote: remote)
  }
}

extension Repository: RepositoryProtocol {
  func searchNews(by query: String) async -> [NKNewsModel] {
    return await NKNewsMapper.transformResponsesToDomains(responses: remote.searchNews(by: query))
  }
  
  func getNewsTopHeadline(by country: NKCountryCode) async -> [NKNewsModel] {
    return await NKNewsMapper.transformResponsesToDomains(responses: remote.fetchNewsTopHeadline(by: country))
  }
}

protocol UseCase: AnyObject {
  func searchNews(by query: String) async throws -> [NKNewsModel]
  func getNewsTopHeadline(by country: NKCountryCode) async throws -> [NKNewsModel]
}

class Interactor: UseCase {
  private var repository: RepositoryProtocol
  
  required init(repository: RepositoryProtocol) {
    self.repository = repository
  }
  
  func searchNews(by query: String) async throws -> [NKNewsModel] {
    return await repository.searchNews(by: query)
  }
  
  func getNewsTopHeadline(by country: NKCountryCode) async throws -> [NKNewsModel] {
    return await repository.getNewsTopHeadline(by: country)
  }
}

@MainActor
class Presenter: ObservableObject {
  private var useCase: UseCase
  
  @Published var news: [NKNewsModel] = []
  @Published var isLoading = false
  @Published var errMessage = ""
  
  init(useCase: UseCase) {
    self.useCase = useCase
  }
  
  func searchNews(query: String) async throws {
    do {
      self.isLoading = true
      self.news = try await useCase.searchNews(by: query)
      self.isLoading = false
    } catch {
      self.errMessage = error.localizedDescription
    }
  }
  
  func getNewsTopHeadline(country: NKCountryCode) async throws {
    do {
      self.isLoading = true
      self.news = try await useCase.getNewsTopHeadline(by: country)
      self.isLoading = false
    } catch {
      self.errMessage = error.localizedDescription
    }
  }
}

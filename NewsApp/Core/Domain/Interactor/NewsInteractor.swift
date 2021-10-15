//
//  NewsInteractor.swift
//  NewsApp
//
//  Created by Ari Supriatna on 14/10/21.
//

import Combine
import Foundation
import NewsKit

class NewsInteractor {
  private var repository: NKNewsRepositoryProtocol
  private var repositoryAsync: NKNewsRepositoryAsyncProtocol
  
  required init(
    repository: NKNewsRepositoryProtocol,
    repositoryAsync: NKNewsRepositoryAsyncProtocol
  ) {
    self.repository = repository
    self.repositoryAsync = repositoryAsync
  }
}

extension NewsInteractor: NKNewsUseCase {
  func searchNews(by query: String) -> AnyPublisher<[NKNewsModel], Error> {
    return repository.searchNews(by: query)
  }
  
  func getNewsByCategory(by category: NKNewsCategory) -> AnyPublisher<[NKNewsModel], Error> {
    return repository.getNewsByCategory(by: category)
  }
  
  func getNewsTopHeadline(by country: NKCountryCode) -> AnyPublisher<[NKNewsModel], Error> {
    return repository.getNewsTopHeadline(by: country)
  }
}

// - MARK: NewsInteractor with Async
extension NewsInteractor: NKNewsUseCaseAsync {
  func searchNews(by query: String) async throws -> [NKNewsModel] {
    return try await repositoryAsync.searchNews(by: query)
  }
  
  func getNewsByCategory(by category: NKNewsCategory) async throws -> [NKNewsModel] {
    return try await repositoryAsync.getNewsByCategory(by: category)
  }
  
  func getNewsTopHeadline(by country: NKCountryCode) async throws -> [NKNewsModel] {
    return try await repositoryAsync.getNewsTopHeadline(by: country)
  }
}

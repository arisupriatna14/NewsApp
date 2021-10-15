//
//  NewsPresenter.swift
//  NewsApp
//
//  Created by Ari Supriatna on 14/10/21.
//

import Combine
import Foundation
import NewsKit
import SwiftUI

@MainActor
class NewsPresenter: ObservableObject {
  private var cancellables: Set<AnyCancellable> = []
  private var useCase: NKNewsUseCase
  private var useCaseAsync: NKNewsUseCaseAsync
  
  @Published var news: [NKNewsModel] = []
  @Published var isLoading = false
  @Published var isError = false
  @Published var errMessage = ""
  
  init(useCase: NKNewsUseCase, useCaseAsync: NKNewsUseCaseAsync) {
    self.useCase = useCase
    self.useCaseAsync = useCaseAsync
  }
  
  func searchNews(query: String) {
    isLoading = true
    
    useCase.searchNews(by: query)
      .sink { completion in
        switch completion {
        case .finished:
          self.isLoading = false
        case .failure(let error):
          self.isError = true
          self.isLoading = false
          self.errMessage = error.localizedDescription
        }
      } receiveValue: { results in
        self.news = results
      }
      .store(in: &cancellables)
  }
  
  func getNewsByCategory(category: NKNewsCategory) {
    isLoading = true
    
    useCase.getNewsByCategory(by: category)
      .sink { completion in
        switch completion {
        case .finished:
          self.isLoading = false
        case .failure(let error):
          self.isError = true
          self.isLoading = false
          self.errMessage = error.localizedDescription
        }
      } receiveValue: { results in
        self.news = results
      }
      .store(in: &cancellables)
  }
  
  func getNewsTopHeadline(country: NKCountryCode) {
    isLoading = true
    
    useCase.getNewsTopHeadline(by: country)
      .sink { completion in
        switch completion {
        case .finished:
          self.isLoading = false
        case .failure(let error):
          self.isError = true
          self.isLoading = false
          self.errMessage = error.localizedDescription
        }
      } receiveValue: { results in
        self.news = results
      }
      .store(in: &cancellables)
  }
  
  // - MARK: Async version
  
  func getNewsByCategory(category: NKNewsCategory) async throws {
    do {
      self.isLoading = true
      self.news = try await useCaseAsync.getNewsByCategory(by: category)
      self.isLoading = false
    } catch {
      self.errMessage = error.localizedDescription
    }
  }
  
  func searchNews(query: String) async throws {
    do {
      self.isLoading = true
      self.news = try await useCaseAsync.searchNews(by: query)
      self.isLoading = false
    } catch {
      self.errMessage = error.localizedDescription
    }
  }
}

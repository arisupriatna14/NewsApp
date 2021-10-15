//
//  Injection.swift
//  NewsApp
//
//  Created by Ari Supriatna on 14/10/21.
//

import Foundation
import NewsKit

final class Injection {
  private func provideNewsRepository() -> NKNewsRepositoryProtocol {
    let remote: NKNewsRemoteDataSource = NKNewsRemoteDataSource.sharedInstance
    
    return NKNewsRepository.sharedInstance(remote)
  }
  
  private func provideNewsRepositoryAsync() -> NKNewsRepositoryAsyncProtocol {
    let remote = NKNewsRemoteDataSource.sharedInstance
    
    return NKNewsRepository.sharedInstance(remote)
  }
  
  private func provideRepository() -> RepositoryProtocol {
    let remote: RemoteDataSource = RemoteDataSource.sharedInstance
    
    return Repository.sharedInstance(remote)
  }
  
  func provideNews() -> NKNewsUseCase {
    let repository = provideNewsRepository()
    let repositoryAsync = provideNewsRepositoryAsync()
    
    return NewsInteractor(repository: repository, repositoryAsync: repositoryAsync)
  }
  
  func provideNewsAsync() -> NKNewsUseCaseAsync {
    let repository = provideNewsRepository()
    let repositoryAsync = provideNewsRepositoryAsync()
    
    return NewsInteractor(repository: repository, repositoryAsync: repositoryAsync)
  }
  
  func provideNewsTopHeadline() -> UseCase {
    let repository = provideRepository()
    
    return Interactor(repository: repository)
  }
}

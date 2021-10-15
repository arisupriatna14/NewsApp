//
//  NewsTopHeadlineView.swift
//  NewsApp
//
//  Created by Ari Supriatna on 15/10/21.
//

import SwiftUI
import NewsKit

struct NewsTopHeadlineView: View {
//  @ObservedObject var presenter = Presenter(useCase: Injection().provideNewsTopHeadline())
  @ObservedObject var presenter = NewsPresenter(
    useCase: Injection().provideNews(),
    useCaseAsync: Injection().provideNewsAsync()
  )
  @State var newsUrl: NKNewsModel?
  @State private var query = ""
  
  var body: some View {
    List(presenter.news) { result in
      NewsRowView(news: result)
        .padding(.vertical, 8)
        .onTapGesture {
          self.newsUrl = result
        }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationTitle(Text("Top Headline Async"))
    .searchable(text: $query, prompt: "Search News")
    .sheet(item: self.$newsUrl) { item in
      SafariView(url: URL(string: item.url)!)
    }
    .onSubmit(of: .search) {
      Task {
        try await self.presenter.searchNews(query: query)
      }
    }
    .task {
      if self.presenter.news.isEmpty {
        try? await self.presenter.getNewsByCategory(category: .health)
      }
    }
    .refreshable {
      try? await self.presenter.getNewsByCategory(category: .health)
    }
  }
}

struct NewsTopHeadlineView_Previews: PreviewProvider {
  static var previews: some View {
    NewsTopHeadlineView()
  }
}

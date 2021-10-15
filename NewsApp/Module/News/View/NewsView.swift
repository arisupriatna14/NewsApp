//
//  NewsView.swift
//  NewsApp
//
//  Created by Ari Supriatna on 14/10/21.
//

import SwiftUI
import NewsKit

struct NewsView: View {
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
    .sheet(item: self.$newsUrl) { item in
      SafariView(url: URL(string: item.url)!)
    }
    .navigationTitle(Text("NewsApp"))
    .searchable(text: $query, prompt: "Search News")
    .onSubmit(of: .search) {
      self.presenter.searchNews(query: self.query)
    }
    .onAppear {
      if self.presenter.news.isEmpty {
        self.presenter.getNewsByCategory(category: .science)
      }
    }
  }
}

struct NewsView_Previews: PreviewProvider {
  static var previews: some View {
    NewsView()
  }
}

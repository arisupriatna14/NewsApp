//
//  NewsRowView.swift
//  NewsApp
//
//  Created by Ari Supriatna on 14/10/21.
//

import SwiftUI
import NewsKit

struct NewsRowView: View {
  
  var news: NKNewsModel
  
  var body: some View {
    HStack {
      AsyncImage(url: URL(string: news.urlToImage)) { image in
        image
          .resizable()
          .scaledToFit()
          .cornerRadius(8)
      } placeholder: {
        ProgressView()
          .frame(width: 170, height: 100)
      }
      
      VStack(alignment: .leading, spacing: 8) {
        Text(news.source.name)
          .font(.caption)
          .foregroundColor(.secondary)
        
        Text(news.title)
          .font(.headline)
          .lineLimit(4)
      }
    }
    .contextMenu(ContextMenu(menuItems: {
      Label("Add to favorite", systemImage: "suit.heart")
    }))
  }
}

struct NewsRowView_Previews: PreviewProvider {
  static var previews: some View {
    NewsRowView(news: .stub)
  }
}

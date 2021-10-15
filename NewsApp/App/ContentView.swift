//
//  ContentView.swift
//  NewsApp
//
//  Created by Ari Supriatna on 14/10/21.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      NavigationView {
        NewsView()
      }
      .tabItem {
        Label("News", systemImage: "newspaper")
      }
      
      NavigationView {
        NewsTopHeadlineView()
      }
      .tabItem {
        Label("Top Headline", systemImage: "books.vertical")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

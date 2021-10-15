//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Ari Supriatna on 14/10/21.
//

import SwiftUI
import NewsKit

@main
struct NewsAppApp: App {
  
  init() {
    NewsKit.register(apiKey: "281aab8a2b9843b284920eb64dc512d6")
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

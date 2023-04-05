//
//  ImageLoader.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 17/03/2023.
//

import Foundation
import UIKit


class ImageLoader: ObservableObject {
  
  let url: String
  
  @Published var image: UIImage? = nil
  @Published var isLoading: Bool = false
  
  static private let cacheCapacity = 1024 * 1024 * 256
  
  init(url: String) {
    self.url = url
    if URLCache.shared.memoryCapacity < Self.cacheCapacity {
      URLCache.shared.memoryCapacity = Self.cacheCapacity
    }
  }
  
  @MainActor
  func fetch() {
    guard image == nil && !isLoading else {
     return
    }
    
    guard let url = URL(string: url) else {
      return
    }
    
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    
    Task {
      isLoading = true
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        isLoading = false
        return
      }
      image = UIImage(data: data)
      isLoading = false
    }
  }
  
}

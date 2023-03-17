//
//  CacheAsyncImage.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 17/03/2023.
//

import SwiftUI

struct CacheAsyncImage: View {
  @StateObject var imageLoader: ImageLoader
  
  init(url: String?) {
    self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url!))
  }
    var body: some View {
      Group {
        if let image = imageLoader.image {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
        } else {
          ZStack {
//            Text(movie.title)
//              .opacity(0.2)
            ProgressView()
          }
        }
      }.onAppear {
        imageLoader.fetch()
      }
    }
}

struct CacheAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
      CacheAsyncImage(url: Movie.avatar.backdropPath)
    }
}

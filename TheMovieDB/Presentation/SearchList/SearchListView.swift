//
//  SearchListView.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 14/03/2023.
//

import SwiftUI

struct SearchListView: View {
  let movies: [Movie]
  let isMovieInWatchList: (Movie) -> Bool
  let addMovieToWatchList: (Movie) -> Void
  let loading: Bool
  
  var body: some View {
    if loading {
      ProgressView()
        .foregroundColor(.white)
        .scaleEffect(2)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else  {
      ScrollView {
        VStack {
          ForEach(movies, id: \.id) { movie in
              SearchListCell(
                movie: movie,
                isMovieInWatchList: isMovieInWatchList(movie),
                addMovieToWatchList: { addMovieToWatchList(movie) }
              )
          }
        }
      }
    }
  }
}

struct SearchListViewProvider_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SearchListView(
        movies: [.avatar, .antMan, .pussInBoots],
        isMovieInWatchList: { _ in true },
        addMovieToWatchList: {_ in print("Add") },
        loading: false
      ).background(Color.BackgroundListView)
      
      SearchListView(
        movies: [.avatar, .antMan, .pussInBoots],
        isMovieInWatchList: { _ in false },
        addMovieToWatchList: {_ in print("Add") },
        loading: false
      ).background(Color.BackgroundListView)
    }
  }
}

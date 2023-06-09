//
//  MoviesListView.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import SwiftUI

struct MoviesListView: View {
  let watchlist: [Movie]
  let popular: [Movie]
  let genres: [Genre]
  
  let fetchMoreMovies:  () async -> Void
  let isLastMovie: (Movie) -> Bool
  
  
  @ViewBuilder var watchlistView: some View {
    VStack (alignment: .leading) {
      Text("Watchlist".uppercased())
        .foregroundColor(.white.opacity(0.56))
      ScrollView(.horizontal) {
        HStack{
          ForEach(watchlist, id: \.id) { movie in
            NavigationLink(value: movie) {
              WatchlistCell(movie: movie)
            }
          }
        }
      }
    }
    .padding()
  }
  
  @ViewBuilder var popularView: some View {
    VStack (alignment: .leading ){
      Text("Popular".uppercased())
        .foregroundColor(.white.opacity(0.56))
      LazyVStack(spacing: 24) {
        ForEach(popular, id: \.id) { movie in
          NavigationLink(value: movie) {
            PopularMovieCell(
              movie: movie,
              genres: genres.filter { movie.genreIds.contains($0.id) }
            )
          }
          .task {
            if isLastMovie(movie) {
              await fetchMoreMovies()
            }
          }
        }
      }
    }
    .padding()
  }
  
  var body: some View {
    ScrollView {
      if watchlist.count > 0 {
        watchlistView
      }
      popularView
    }
    
  }
}

struct MoviesListView_Previews: PreviewProvider {
  static var previews: some View {
    MoviesListView(
      watchlist:  [.blackPanther, .creed, .pussInBoots, .antMan, .avatar],
      popular:  [.blackPanther, .creed, .pussInBoots, .antMan, .avatar],
      genres: [],
      fetchMoreMovies: { print("Fetch more") },
      isLastMovie: { $0.id == Movie.avatar.id }
    )
    .background(Color.BackgroundListView)
  }
}

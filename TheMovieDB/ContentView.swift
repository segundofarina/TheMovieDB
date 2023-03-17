//
//  ContentView.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var moviesViewModel = MoviesListViewModel()
  @StateObject private var searchViewModel = SearchViewModel()
  
  @Environment(\.scenePhase) private var scenePhase
  
  
  init() {
    self.initNavigationBarAppearance()
  }
  
  var body: some View {
    NavigationStack {
      Group {
        if(searchViewModel.searchQuery != "") {
          SearchListView(movies: searchViewModel.searchedResults,
                         isMovieInWatchList: { moviesViewModel.isMovieInWatchList(movie: $0) },
                         addMovieToWatchList: { moviesViewModel.addToWatchList(movie: $0) },
                         loading: searchViewModel.state == .fetching
          )
        } else  {
          MoviesListView(
            watchlist: moviesViewModel.watchlist,
            popular: moviesViewModel.popular,
            genres: moviesViewModel.genres,
            fetchMoreMovies: moviesViewModel.fetchMoreMovies,
            isLastMovie: moviesViewModel.isLastMovie
          )
        }
      }
      .edgesIgnoringSafeArea([.bottom])
      .navigationDestination(for: Movie.self) { movie in
        MovieDetailView(
          movie: movie,
          addToWatchList: { moviesViewModel.addToWatchList(movie: movie) },
          removeFromWatchList: { moviesViewModel.removeFromWatchList(movie: movie) },
          isOnWatchList: moviesViewModel.isMovieInWatchList(movie: movie)
        )
      }
      .searchable(text: $searchViewModel.searchQuery)
      .background(Color.BackgroundListView)
      .preferredColorScheme(.dark)
      .onAppear {
        moviesViewModel.fetchInitialData()
      }
      .onChange(of: scenePhase) { phase in
        if phase == .inactive { moviesViewModel.persist() }
      }
      
    }
    
  }
  
  private func initNavigationBarAppearance() {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithDefaultBackground()
    navBarAppearance.backgroundColor = UIColor(Color.BackgroundListView)
    UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    UINavigationBar.appearance().compactScrollEdgeAppearance = navBarAppearance
    UINavigationBar.appearance().compactAppearance = navBarAppearance
    UINavigationBar.appearance().standardAppearance = navBarAppearance
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

//
//  ContentView.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = MoviesListViewModel()
  
  init() {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithDefaultBackground()
    navBarAppearance.backgroundColor = UIColor(Color.BackgroundListView)
    UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    UINavigationBar.appearance().compactScrollEdgeAppearance = navBarAppearance
    UINavigationBar.appearance().compactAppearance = navBarAppearance
    UINavigationBar.appearance().standardAppearance = navBarAppearance
  }
  
  var body: some View {
    NavigationStack {
      Group {
        if(viewModel.searchQuery != "") {
          SearchListView(movies: viewModel.searchedResults,
                         isMovieInWatchList: { viewModel.watchlist.contains($0) },
                         addMovieToWatchList: { viewModel.addToWatchList(movie: $0)},
                         loading: viewModel.searchedResults.count == 0
                         
          )
        } else  {
          MoviesListView(
            watchlist: viewModel.watchlist,
            popular: viewModel.popular,
            genres: viewModel.genres
          )
        }
      }
      .edgesIgnoringSafeArea([.bottom])
     
      .navigationDestination(for: Movie.self) { movie in
        MovieDetailView(
          movie: movie,
          addToWatchList: { viewModel.addToWatchList(movie: movie) },
          removeFromWatchList: { viewModel.removeFromWatchList(movie: movie) },
          isOnWatchList: viewModel.watchlist.contains(movie)
        )
      }
      .searchable(text: $viewModel.searchQuery)
      .foregroundColor(.white)
      .background(Color.BackgroundListView)
      .onAppear {
        viewModel.fetchInitialData()
      }
      .preferredColorScheme(.dark)
    }
    
  }
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

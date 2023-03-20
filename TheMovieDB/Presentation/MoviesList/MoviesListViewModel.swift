//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 14/03/2023.
//

import Foundation
import Combine

@MainActor
class MoviesListViewModel: ObservableObject {
  
  @Published var watchlist: [Movie] = []
  @Published var popular: [Movie] = []
  @Published var genres: [Genre] = []
  
  private let apiClient: APIClient
  private var currentPage = 0
  private let moviePersistence: MoviePersistence
  
  var state: State = .idle
  
  init(apiClient: APIClient = APIClient.shared, moviePersistence: MoviePersistence = MoviePersistence()) {
    self.apiClient = apiClient
    self.moviePersistence = moviePersistence
  }
  
  func fetchInitialData() {
    if state != .idle { return }
    print("Fetch initial data")
    Task {
      self.state = .fetching
      
      // CHECK parallel async
      let list = try await apiClient.getPopularMovies()
      self.popular = list.results
      if let page = list.page {
        self.currentPage = page
      }
      self.genres = try await apiClient.getMovieGenres()
      self.watchlist = await moviePersistence.getWatchlist()
      self.state = .fetched
    }
  }
  
  public func addToWatchList(movie: Movie) {
    if !watchlist.contains(movie) {
      watchlist.append(movie)
    }
  }
  
  public func removeFromWatchList(movie: Movie) {
    watchlist.removeAll(where: {$0.id == movie.id})
  }
  
  public func isMovieInWatchList(movie: Movie) -> Bool {
    return watchlist.contains(movie)
  }
  
  // Endless scroll
  public func isLastMovie(movie: Movie) -> Bool {
    popular.last?.id == movie.id
  }
  
  public func fetchMoreMovies() {
    if state == .fetching { return }
    
    Task  {
      state = .fetching
      print("fetching page: \(currentPage + 1)")
      let list = try await apiClient.getPopularMovies(page: currentPage + 1)
      state = .fetched
      self.popular.append(contentsOf: list.results)
      if let page = list.page {
        self.currentPage = page
      }
    }
  }
  
  public func persist() {
    Task {
      await moviePersistence.saveWatchlist(watchlist: watchlist)
    }
  }
  
}

extension MoviesListViewModel {
  enum State {
    case idle
    case fetching
    case fetched
  }
}

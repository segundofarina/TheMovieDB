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
 
  
  init(apiClient: APIClient = APIClient.shared) {
    self.apiClient = apiClient
  }
  
  func fetchInitialData() {
    Task {
      self.popular = try await apiClient.getPopularMovies().results
      self.genres = try await apiClient.getMovieGenres()
    }
  }
  
  public func addToWatchList(movie: Movie) {
    if !watchlist.contains(movie) {
      watchlist.append(movie)
    }
  }
  
  public func isLastMovie(movie: Movie) -> Bool {
    popular.last?.id == movie.id
  }
  
  public func removeFromWatchList(movie: Movie) {
    watchlist.removeAll(where: {$0.id == movie.id})
  }
  
  public func isMovieInWatchList(movie: Movie) -> Bool {
    return watchlist.contains(movie)
  }
  
}

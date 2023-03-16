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
  
  @Published var searchedResults: [Movie] = []
  @Published var searchQuery = ""
  
  private let apiClient: APIClient
  private var cancellables = Set<AnyCancellable>()
  
  init(apiClient: APIClient = APIClient.shared) {
    self.apiClient = apiClient
    $searchQuery
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .sink { [weak self] query in
        self?.searchForMovie(query: query)
      }
      .store(in: &cancellables)
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
  
  public func removeFromWatchList(movie: Movie) {
    watchlist.removeAll(where: {$0.id == movie.id})
  }
  
  private func searchForMovie(query: String) {
    Task {
      self.searchedResults = try await apiClient.searchForMovie(query: query).results
    }
  }
  
}

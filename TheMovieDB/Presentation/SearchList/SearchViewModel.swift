//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 16/03/2023.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
  @Published var searchedResults: [Movie] = []
  @Published var searchQuery = ""
  @Published var state: State = .idle
  
  
  private let apiClient: APIClient
  private var cancellables = Set<AnyCancellable>()
  
  init(apiClient: APIClient = APIClientImplementation.shared) {
    self.apiClient = apiClient
    $searchQuery
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .sink { [weak self] query in
        guard query != "" else {
          self?.state = .idle
          self?.searchedResults = []
          return
        }
        self?.searchForMovie(query: query)
      }
      .store(in: &cancellables)
    
    $searchQuery
      .sink { [weak self] query in
        if self?.state == .idle {
          self?.state = .fetching
        }
      }
      .store(in: &cancellables)
  }
  
  
  private func searchForMovie(query: String) {
    Task {
      self.searchedResults = try await apiClient.searchForMovie(query: query).results
      state = .fetched
    }
  }
  
  
}

extension SearchViewModel {
  enum State {
    case idle
    case fetching
    case fetched
  }
}

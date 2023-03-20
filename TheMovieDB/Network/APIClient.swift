//
//  APIClient.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import Foundation

class APIClient {
  
  static let shared = APIClient(networkClient: URLSessionNetworkClient())
  
  private let networkClient: NetworkClient
  
  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }
  
  func getPopularMovies(page: Int = 1) async throws -> MovieList {
    let endpoint = Endpoint(path: "/movie/popular")
      .query(key: "page", value: "\(page)")
    return try await networkClient
      .sendRequest(endpoint: endpoint)
      .onStatus(200, decodeUsing: MovieList.self)
  }
  
  func getMovieGenres() async throws -> [Genre] {
    let endpoint = Endpoint(path: "/genre/movie/list")
    
    return try await networkClient
      .sendRequest(endpoint: endpoint)
      .onStatus(200, decodeUsing: GenreList.self)
      .genres
  }
  
  func searchForMovie(query: String) async throws -> MovieList {
    let endpoint = Endpoint(path: "/search/movie")
      .query(key: "query", value: query)
    return try await networkClient
      .sendRequest(endpoint: endpoint)
      .onStatus(200, decodeUsing: MovieList.self)
  }
  
}

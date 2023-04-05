//
//  NetworkClient.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import Foundation


protocol NetworkClient {
  func sendRequest(endpoint: Endpoint) async -> Response
}

struct URLSessionNetworkClient: NetworkClient {
  
  private let session: URLSession
  
  init() {
    let token = Self.getToken()
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    session = URLSession(configuration: config)
  }
  
  /// Looks for the api token that is stored on the .xconfig file
  /// - Returns: the api token
  private static func getToken() -> String {
    guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { return "" }
    guard let apiKey: String = infoDictionary["API_TOKEN"] as? String else { return "" }
    return apiKey
  }
  
  func sendRequest(endpoint: Endpoint) async -> Response {
    do {
      let (data, res) = try await session.data(for: endpoint.asRequest())
      return Response(data: data, response: res, path: endpoint.url.relativePath, error: nil )
    } catch {
      return Response(path: endpoint.url.relativePath, error: error)
    }
  }
}



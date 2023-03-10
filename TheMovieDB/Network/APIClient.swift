//
//  APIClient.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import Foundation


protocol APIClient {
  func sendRequest(endpoint:Endpoint) async -> Response
}

struct URLSessionAPIClient: APIClient {
  
  private let session = URLSession.shared
  
  func sendRequest(endpoint:Endpoint) async -> Response {
    do {
      let (data, res) = try await session.data(for: endpoint.asRequest())
      return Response(data: data, response: res, path: endpoint.url.relativePath, error: nil )
      
    } catch {
      return Response(path: endpoint.url.relativePath, error: error)
    }
  }
}

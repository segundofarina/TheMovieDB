//
//  Endpoint.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import Foundation

/// Endpoint definition
/// The definition is intended to be easily readable & explainable at a glance.
struct Endpoint {
  
  static let defaultHeaders = [
    "Accept":"application/json, text/plain, */*",
    "content-type":"application/json;charset=utf-8"]
  
  static let scheme = "https"
  static let host = "api.themoviedb.org"
  
  
  enum Method: String {
    case get    = "GET"
    case post   = "POST"
    case delete = "DELETE"
    case put    = "PUT"
  }
  
  private (set) var url: URL
  private (set) var method: Method = .get
  private (set) var timeout: Double = 60
  private (set) var headers: [String:String] = defaultHeaders
  private (set) var queryParams: [String:String] = [:]
  private (set) var body: Data?
  
  
  /// Initialize Endpoint  for POSAdapter using URL path
  /// - Parameters:
  ///   - path: Path of POSAdapter URL to append to hostname & port
  ///   - params: Query parameter key/value pairs
  init(path: String, params: [String:String] = [:]) {
    var components = URLComponents()
    components.scheme = Self.scheme
    components.host = Self.host
    components.path = "/3"
    
    
    guard let validURL = components.url?.appendingPathComponent(path) else {
      fatalError("Invalid URL using '\(path)'")
    }
    
    self.url = validURL
    self.queryParams = params
  }
  
  /// Sets request method for returned endpoint
  /// - Parameter value: Request method to use (.get, .post, etc..)
  /// - Returns: Endpoint instance
  func method(_ value: Method) -> Endpoint {
      var newEndpoint = self
      newEndpoint.method = value
      return newEndpoint
  }
  
  /// Sets timeout duration for requests made on returned endpoint
  /// - Parameter value: Duration to wait for a response before the request times out in seconds
  /// - Returns: Endpoint instance
  func timeout(_ value: Double) -> Endpoint {
      var newEndpoint = self
      newEndpoint.timeout = value
      return newEndpoint
  }
  
  /// Sets body for endpoint request
  /// - Parameter value: Data to be included in request body
  /// - Returns: Endpoint instance
  func body(_ value: Data) -> Endpoint {
    var newEndpoint = self
    newEndpoint.body = value
    return newEndpoint
  }
  
  /// Sets/Updates query parameter key/value pair
  /// - Parameters:
  ///   - key: Query parameter name
  ///   - value: Query parameter value String
  /// - Returns: Endpoint instance
  func query(key: String, value: String) -> Endpoint {
    var newEndpoint = self
    newEndpoint.queryParams.updateValue(value, forKey: key)
    return newEndpoint
  }
  
  /// Sets/Updates header key/value pair
  /// - Parameters:
  ///   - key: Header parameter name
  ///   - value: Header parameter value
  /// - Returns: Endpoint instance
  func header(_ key: String, _ value: String) -> Endpoint {
    var newEndpoint = self
    newEndpoint.headers.updateValue(value, forKey: key)
    return newEndpoint
  }
  
  /// Updates the endpoint to include the 'access-token' header
  /// - Returns: Endpoint instance
  func withAuth(accessToken: String) -> Endpoint {
    var newEndpoint = self
    newEndpoint.headers.updateValue("Bearer \(accessToken)", forKey: "authorization")
    return newEndpoint
  }
  
  /// Uses data defined in the endpoint properties to create a URLRequest
  /// - Returns: URLRequest grenerated from the endpoint instance
  func asRequest() -> URLRequest {
    var request = URLRequest(url: url, timeoutInterval: self.timeout)
    request.httpMethod = "\(self.method)"
    request.allHTTPHeaderFields = self.headers
    if !self.queryParams.isEmpty {
      request.url?.append(queryItems: self.queryParams.map({ URLQueryItem(name: $0.key, value: $0.value) }))
    }
    if let data = self.body {
      request.httpBody = data
    }
    return request
  }
  
}

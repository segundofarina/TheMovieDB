//
//  Response.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import Foundation

struct Response {
  var data: Data?
  var response: URLResponse?
  var path: String = ""
  var error: Error?
  
  var httpStatusCode: Int {
    let httpResponse = response as? HTTPURLResponse
    return httpResponse?.statusCode ?? -1
  }
  
  init(data: Data? = nil, response: URLResponse? = nil, path: String = "", error: Error? = nil) {
    self.data = data
    self.response = response
    self.path = path
    self.error = error
  }
  
  @discardableResult func onStatus<T>(_ status: Int, return value: T) -> T? {
    if status == httpStatusCode {
      return value
    }
    return nil
  }
  
  func onStatus(_ status: Int, throw error: Error) throws -> Response {
    try onStatus(status, {(_,_) in throw error})
  }
  
  @discardableResult func onStatus(_ status: Int, _ callback: (Data, URLResponse) throws -> Void) throws -> Response {
    let newResponse = self
    guard let dat = data, let res = response else {
      return newResponse
    }
    if status == httpStatusCode {
      try callback(dat, res)
    }
    return newResponse
  }
  
  
  @discardableResult func onStatus<T>(_ status: Int, decodeUsing: T.Type) throws -> T where T : Decodable {
    if let error = error {
      throw error
    }
    if status == httpStatusCode, let data {
      do {
        let result = try JSONDecoder().decode(decodeUsing, from: data)
        return result
      } catch {
        print(error)
        throw APIError.decodingError
      }
    }
    throw APIError.invalidResponse
  }
  
}



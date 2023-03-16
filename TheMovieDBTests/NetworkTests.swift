//
//  NetworkTests.swift
//  TheMovieDBTests
//
//  Created by Segundo Fariña on 14/03/2023.
//

import XCTest
@testable import TheMovieDB

final class NetworkTests: XCTestCase {
  
  func test_getToken_returnsNonEmpty() {
    let token = URLSessionNetworkClient.getToken()
    XCTAssertNotEqual(token, "")
  }
  

}

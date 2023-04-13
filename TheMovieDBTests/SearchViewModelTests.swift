//
//  SearchViewModelTests.swift
//  TheMovieDBTests
//
//  Created by Segundo Fariña on 13/04/2023.
//

import XCTest
@testable import TheMovieDB

@MainActor
final class SearchViewModelTests: XCTestCase {
  
  
  func makeSUT() -> SearchViewModel {
    let apiClient = ApiClientSpy()
    return SearchViewModel(apiClient: apiClient)
  }
  
  func test_state_isInitiallyIdle() {
    let sut = makeSUT()
    XCTAssertEqual(sut.state, .idle)
  }
  
  func test_searchQuery_IsInitiallyEmpty() {
    let sut = makeSUT()
    XCTAssertEqual(sut.searchQuery, "")
  }
  
  func test_searchedResults_AreInitiallyEmpty() {
    let sut = makeSUT()
    XCTAssertEqual(sut.searchedResults.count, 0)
  }
  
  func test_updateSearchQuery_updatesSearchedResults() {
    let sut = makeSUT()
    
    let expectation = self.expectation(description: "Searched result changed")
    
    let subscription = sut.$searchedResults
      .dropFirst()
      .sink { _ in
        expectation.fulfill()
      }
    
    sut.searchQuery = "a"
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(sut.searchedResults.count, 2)
  }
  
  func test_updateSearchQuery_updatesState() {
    let sut = makeSUT()
    
    let stateIsFetchingExpectation = self.expectation(description: "Stat is fetching")
    let stateIsFetchedExpectation = self.expectation(description: "State is fetched")
    
    
    let subscription = sut.$state
      .dropFirst()
      .sink { state in
        if state == .fetching { stateIsFetchingExpectation.fulfill() }
        if state == .fetched { stateIsFetchedExpectation.fulfill() }
      }
    
    sut.searchQuery = "a"
    
    wait(for: [stateIsFetchingExpectation], timeout: 1)
    wait(for: [stateIsFetchedExpectation], timeout: 1)
  }
  
  func test_eraseSearchTerm_deletesSearchedResult() {
    let sut = makeSUT()
    let expectation1 = self.expectation(description: "Searched result changed")
    let expectation2 = self.expectation(description: "Searched result changed")
    
    let subscription1 = sut.$searchedResults
      .dropFirst()
      .sink { _ in
        expectation1.fulfill()
      }
    
    let subscription2 = sut.$searchedResults
      .dropFirst(2)
      .sink { _ in
        expectation2.fulfill()
      }
    
    sut.searchQuery = "a"
    wait(for: [expectation1], timeout: 1)
    subscription1.cancel()
    XCTAssertNotEqual(sut.searchedResults.count, 0)
    
    sut.searchQuery = ""
    wait(for: [expectation2], timeout: 1)
    
    XCTAssertEqual(sut.searchedResults.count, 0)
  }
  
}

extension SearchViewModelTests {
  class ApiClientSpy: APIClient {
    let movies: [Movie] = [.antMan, .avatar, .blackPanther, .creed, .pussInBoots]
    
    func getPopularMovies(page: Int) async throws -> MovieList {
      MovieList(results: movies, page: 1)
    }
    
    func getMovieGenres() async throws -> [Genre] {
      []
    }
    
    func searchForMovie(query: String) async throws -> MovieList {
      let results = movies.filter{ $0.title.lowercased().starts(with: query.lowercased()) }
      return MovieList(results: results, page: 1)
    }
  }
}

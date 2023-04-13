//
//  MoviesViewModelTests.swift
//  TheMovieDBTests
//
//  Created by Segundo Fariña on 19/03/2023.
//

import XCTest
@testable import TheMovieDB

@MainActor
final class MoviesViewModelTests: XCTestCase {
  
  func makeSUT() -> MoviesListViewModel {
    let apiClient: APIClient = ApiClientStub()
    let moviePersistence: MoviePersistence = MoviePersistenceSpy()
    return MoviesListViewModel(apiClient: apiClient, moviePersistence: moviePersistence)
  }
  
  func test_popularArray_isInitiallyEmpty() {
    let sut = makeSUT()
    XCTAssertEqual(sut.popular.count, 0)
  }
  
  func test_state_isInitiallyIdle() {
    let sut = makeSUT()
    XCTAssertEqual(sut.state, .idle)
  }
  
  func test_fetchInitialData_changesState() {
    let sut = makeSUT()
    let stateIsFetchingExpectation = self.expectation(description: "State changed to fetching")
    let stateIsFetchedExpectation = self.expectation(description: "State changed to fetched")
    
    let subscription = sut
      .$state
      .sink { state in
        if state == .fetching { stateIsFetchingExpectation.fulfill() }
        if state == .fetched { stateIsFetchedExpectation.fulfill() }
      }
   
    sut.fetchInitialData()
    wait(for: [stateIsFetchingExpectation], timeout: 1)
    wait(for: [stateIsFetchedExpectation], timeout: 1)
    subscription.cancel()
  }
  
  func test_fetchInitialData_populatesMovies() {
    let sut = makeSUT()
    let popularChangedExpectation = self.expectation(description: "wait for popular array to change")
    let subscription = sut
      .$popular
      .dropFirst()
      .sink { _ in
        popularChangedExpectation.fulfill()
      }
    sut.fetchInitialData()
    wait(for: [popularChangedExpectation], timeout: 1)
    XCTAssertNotEqual(sut.popular.count, 0)
    subscription.cancel()
  }
  
  func test_fetchInitialData_populatesWatchlist() {
    let sut = makeSUT()
    let watchlistChangedExpectation = self.expectation(description: "wait for watchlist array to change")
    let subscription = sut
      .$watchlist
      .dropFirst()
      .sink { _ in
        watchlistChangedExpectation.fulfill()
      }
    sut.fetchInitialData()
    wait(for: [watchlistChangedExpectation], timeout: 1)
    XCTAssertNotEqual(sut.watchlist.count, 0)
    subscription.cancel()
  }
  
  func test_fetchInitialData_populatesGenres() {
    let sut = makeSUT()
    let genresChangedExpectation = self.expectation(description: "wait for genres array to change")
    let subscription = sut
      .$genres
      .dropFirst()
      .sink { _ in
        genresChangedExpectation.fulfill()
      }
    sut.fetchInitialData()
    wait(for: [genresChangedExpectation], timeout: 1)
    XCTAssertNotEqual(sut.genres.count, 0)
    subscription.cancel()
  }
  
  func test_fetchMoreMovies_addsMoreMovies() {
    let sut = makeSUT()
    let popularInitialized = self.expectation(description: "popular array initialized")
    let popularFetched = self.expectation(description: "popular fetched")
    let popularUpdatedExpectation = self.expectation(description: "added more movies to popular")
    let initialSubscription = sut
      .$popular
      .dropFirst()
      .sink { _ in
        popularInitialized.fulfill()
      }
    let initialSubscriptionFetch = sut
      .$state
      .sink { state in
        if state == .fetched { popularFetched.fulfill()}
      }
    
    let subscription = sut
      .$popular
      .dropFirst(2)
      .sink { _ in
        popularUpdatedExpectation.fulfill()
      }
    
    sut.fetchInitialData()
    wait(for: [popularInitialized, popularFetched], timeout: 1)
    initialSubscription.cancel()
    initialSubscriptionFetch.cancel()
    
    sut.fetchMoreMovies()
    
    wait(for: [popularUpdatedExpectation], timeout: 1)
    
    XCTAssertEqual(sut.popular.count, 5)
    
  }
  
}

extension MoviesViewModelTests {
  struct ApiClientStub: APIClient {
    let popular: [ Int: [Movie] ] =
    [
      1 : [.antMan, .avatar, .blackPanther],
      2 : [.creed, .pussInBoots]
    ]
    
    let genres: [Genre] = [.action, .comedy]
    
    func getPopularMovies(page: Int) async throws -> TheMovieDB.MovieList {
      return MovieList(results: popular[page] ?? [], page: page)
    }
    
    func getMovieGenres() async throws -> [TheMovieDB.Genre] {
      return genres
    }
    
    func searchForMovie(query: String) async throws -> TheMovieDB.MovieList {
      return MovieList(results: popular[1] ?? [], page: 1)
    }
    
    
  }
  
}

extension MoviesViewModelTests {
  class MoviePersistenceSpy: MoviePersistence {
    var watchlist: [Movie] = [.antMan]
    
    func getWatchlist() async -> [TheMovieDB.Movie] {
      return watchlist
    }
    
    func saveWatchlist(watchlist: [TheMovieDB.Movie]) async {
      self.watchlist = watchlist
    }
    
    
  }
}

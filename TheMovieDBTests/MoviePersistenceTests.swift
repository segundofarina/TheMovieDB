//
//  MoviePersistenceTests.swift
//  TheMovieDBTests
//
//  Created by Segundo Fariña on 17/03/2023.
//

import XCTest
@testable import TheMovieDB

final class MoviePersistenceTests: XCTestCase {

  func makeSut() -> MoviePersistence {
    return MoviePersistence()
  }
  
  func test_savesMovie() {
    let sut = makeSut()
    let watchlist: [Movie] = [.avatar, .antMan]
    sut.saveWatchlist(watchlist: watchlist)
    
    let result = sut.getWatchlist()
    
    XCTAssertEqual(watchlist, result)
  }
  
  func test_saveTwice_loadsLast() {
    let sut = makeSut()
    let watchlist: [Movie] = [.avatar, .antMan]
    sut.saveWatchlist(watchlist: watchlist)
    let watchlist2: [Movie] = [.pussInBoots, .blackPanther]
    sut.saveWatchlist(watchlist: watchlist2)
    let result = sut.getWatchlist()
    XCTAssertEqual(watchlist2, result)
  }

}

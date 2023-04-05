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
  
  func test_savesMovie() async {
    let sut = makeSut()
    let watchlist: [Movie] = [.avatar, .antMan]
    await sut.saveWatchlist(watchlist: watchlist)

    let result = await sut.getWatchlist()
    
    XCTAssertEqual(watchlist, result)
  }
  
  func test_saveTwice_loadsLast() async {
    let sut = makeSut()
    let watchlist: [Movie] = [.avatar, .antMan]
    await sut.saveWatchlist(watchlist: watchlist)
    let watchlist2: [Movie] = [.pussInBoots, .blackPanther]
    await sut.saveWatchlist(watchlist: watchlist2)
    let result = await sut.getWatchlist()
    XCTAssertEqual(watchlist2, result)
  }

}

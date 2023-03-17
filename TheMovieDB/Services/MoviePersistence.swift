//
//  MoviePersistence.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 17/03/2023.
//

import Foundation


struct MoviePersistence {
  struct WatchlistDiskOperator: DiskOperator {
    typealias Model = [Movie]
    let fileName: String = "Watchlist"
  }
  
  private let diskOperator = WatchlistDiskOperator()
  
  func getWatchlist() async -> [Movie] {
    return (try? await diskOperator.load()) ?? []
  }
  
  func saveWatchlist(watchlist: [Movie]) async {
    try? await diskOperator.save(model: watchlist)
  }
}


protocol DiskOperator {
  associatedtype Model: Codable
  
  var fileName: String { get }
  
  func save(model: Model) async throws -> Void
  
  func load() async throws -> Model
}

extension DiskOperator {
  
  func fileURL() throws -> URL {
          try FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: false)
              .appendingPathComponent("\(fileName).json")
  }
  
  
  
  
  func load(completion: @escaping (Result<Model, Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let fileURL = try fileURL()
        let file = try FileHandle(forReadingFrom: fileURL)
        let model = try JSONDecoder().decode(Model.self, from: file.availableData)
        DispatchQueue.main.async {
          completion(.success(model))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
  func save(model: Model, completion: @escaping (Result<Void, Error>)->Void) {
          DispatchQueue.global(qos: .background).async {
              do {
                  let data = try JSONEncoder().encode(model)
                  let outfile = try fileURL()
                  try data.write(to: outfile)
                  DispatchQueue.main.async {
                      completion(.success(()))
                  }
              } catch {
                  DispatchQueue.main.async {
                      completion(.failure(error))
                  }
              }
          }
      }
  
  func load() async throws -> Model {
      try await withCheckedThrowingContinuation { continuation in
          load { result in
              switch result {
              case .failure(let error):
                  continuation.resume(throwing: error)
              case .success(let model):
                  continuation.resume(returning: model)
              }
          }
      }
  }
  
  func save(model: Model) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
          save(model: model) { result in
              switch result {
              case .failure(let error):
                  continuation.resume(throwing: error)
              case .success:
                continuation.resume()
              }
          }
      }
  }
  
}

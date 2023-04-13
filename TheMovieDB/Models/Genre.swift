//
//  GenreItemResponse.swift
//

import Foundation

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

extension Genre {
  static let action = Genre(id: 1, name: "Action")
  static let comedy = Genre(id: 2, name: "Comedy")
}

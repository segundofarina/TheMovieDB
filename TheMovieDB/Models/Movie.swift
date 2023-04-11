//
//  Movie.swift
//

import Foundation

struct Movie: Codable, Hashable {
  let id: Int
  let overview: String
  let releaseDate: String
  let title: String
  let backdropPath: String?
  let posterPath: String?
  let genreIds: [Int]
}

extension Movie {
  static let CDN_URL: String = "https://image.tmdb.org/t/p/"
  
  func posterURL(size: PosterSize)-> String? {
    guard let posterPath = posterPath else { return nil }
    return "\(Self.CDN_URL)/\(size.rawValue)/\(posterPath)"
  }
  
  func backdropURL(size: BackdropSize) -> String? {
    guard let backdropPath = backdropPath else {return nil}
    return "\(Self.CDN_URL)/\(size.rawValue)/\(backdropPath)"
  }
  
  enum BackdropSize: String {
    case w300
    case w780
    case w1280
    case original
  }
  
  enum PosterSize: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
  }
}

extension Movie {
  
  enum CodingKeys: String, CodingKey  {
    case id
    case overview
    case releaseDate = "release_date"
    case title
    case backdropPath = "backdrop_path"
    case posterPath = "poster_path"
    case genreIds = "genre_ids"
  }
  
  init(from decoder: Decoder) throws {
    let values   = try decoder.container(keyedBy: CodingKeys.self)
    
    id           = try values.decode(Int.self, forKey: .id)
    overview     = try values.decode(String.self, forKey: .overview)
    releaseDate  = try values.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
    title        = try values.decode(String.self, forKey: .title)
    backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
    posterPath   = try values.decodeIfPresent(String.self, forKey: .posterPath)
    genreIds     = try values.decodeIfPresent([Int].self, forKey: .genreIds) ?? []
  }
}

extension Movie {
  static let blackPanther: Movie = Movie(
    id: 505642,
    overview: "Queen Ramonda, Shuri, M’Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T’Challa’s death.  As the Wakandans strive to embrace their next chapter, the heroes must band together with the help of War Dog Nakia and Everett Ross and forge a new path for the kingdom of Wakanda.",
    releaseDate: "2022-11-09",
    title: "Black Panther: Wakanda Forever",
    backdropPath: "/xDMIl84Qo5Tsu62c9DGWhmPI67A.jpg",
    posterPath: "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg",
    genreIds: [
      28,
      12,
      878
    ]
  )
  static let pussInBoots: Movie = Movie(
    id: 315162,
    overview: "Puss in Boots discovers that his passion for adventure has taken its toll: He has burned through eight of his nine lives, leaving him with only one life left. Puss sets out on an epic journey to find the mythical Last Wish and restore his nine lives.",
    releaseDate: "2022-12-07",
    title: "Puss in Boots: The Last Wish",
    backdropPath: "/jr8tSoJGj33XLgFBy6lmZhpGQNu.jpg",
    posterPath: "/kuf6dutpsT0vSVehic3EZIqkOBt.jpg",
    genreIds: [
      16,
      12,
      35,
      10751
    ])
  
  static let antMan: Movie = Movie(
    id: 640146,
    overview: "Super-Hero partners Scott Lang and Hope van Dyne, along with with Hope's parents Janet van Dyne and Hank Pym, and Scott's daughter Cassie Lang, find themselves exploring the Quantum Realm, interacting with strange new creatures and embarking on an adventure that will push them beyond the limits of what they thought possible.",
    releaseDate: "2023-02-15",
    title: "Ant-Man and the Wasp: Quantumania",
    backdropPath: "/3JSoB7eMbCd8sE8alxNiUtrNiTz.jpg",
    posterPath: "/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg",
    genreIds: [
      12,
      878,
      35
    ])
  
  static let avatar: Movie = Movie(
    id: 76600,
    overview: "Set more than a decade after the events of the first film, learn the story of the Sully family (Jake, Neytiri, and their kids), the trouble that follows them, the lengths they go to keep each other safe, the battles they fight to stay alive, and the tragedies they endure.",
    releaseDate: "2022-12-14",
    title: "Avatar: The Way of Water",
    backdropPath: "/ovM06PdF3M8wvKb06i4sjW3xoww.jpg",
    posterPath: "/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg",
    genreIds: [
      878,
      12,
      28
    ])
  
  static let creed: Movie = Movie(
    id: 677179,
    overview: "After dominating the boxing world, Adonis Creed has been thriving in both his career and family life. When a childhood friend and former boxing prodigy, Damien Anderson, resurfaces after serving a long sentence in prison, he is eager to prove that he deserves his shot in the ring. The face-off between former friends is more than just a fight. To settle the score, Adonis must put his future on the line to battle Damien - a fighter who has nothing to lose.",
    releaseDate: "2023-03-01",
    title: "Creed III",
    backdropPath: "/5i6SjyDbDWqyun8klUuCxrlFbyw.jpg",
    posterPath: "/vJU3rXSP9hwUuLeq8IpfsJShLOk.jpg",
    genreIds: [
      18,
      28
    ])
  
}

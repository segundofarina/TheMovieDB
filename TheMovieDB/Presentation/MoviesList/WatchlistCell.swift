//
//  WatchlistCell.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import SwiftUI

struct WatchlistCell: View {
  let movie: Movie
    var body: some View {
      CacheAsyncImage(url: movie.posterURL(size: .w154))
        .frame(width: 100, height: 154)
    }
}

struct WatchlistCell_Previews: PreviewProvider {
    static var previews: some View {
      WatchlistCell(movie: .blackPanther)
    }
}

//
//  PopularMovieCell.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import SwiftUI

struct PopularMovieCell: View {
  let movie: Movie
  let genres: [Genre]
  
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Text(genres.first?.name.uppercased() ?? "")
          .bold()
          .foregroundColor(.white.opacity(0.67))
          .padding([.top,.bottom],4)
          .padding([.leading, .trailing], 12)
          .background {
            RoundedRectangle(cornerRadius: 3).fill(Color.black.opacity(0.4))
          }
      }
      Spacer()
      HStack {
        Text(movie.title)
          .bold()
          .foregroundColor(.iceBlue)
        Spacer()
      }
    }
    .padding([.top, .bottom], 4)
    .padding()
    
    
    .background(AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780/\(movie.backdropPath ?? "")")) { image in
      image
        .resizable()
        .scaledToFill()
    } placeholder: {
      ZStack {
        Text(movie.title)
          .opacity(0.2)
        ProgressView()
      }
    })
    .frame(height: 156)
    .frame(maxWidth: .infinity)
    .clipped()
    .clipShape(RoundedRectangle(cornerRadius: 3))
    
  }
}

struct PopularMovieCell_Previews: PreviewProvider {
  static var previews: some View {
    PopularMovieCell(movie: .avatar, genres: [])
  }
}
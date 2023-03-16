//
//  SearchListCell.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 15/03/2023.
//

import SwiftUI

struct SearchListCell: View {
  let movie: Movie
  let isMovieInWatchList: Bool
  let addMovieToWatchList: () -> Void
  
  var imageView: some View {
    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300/\(movie.posterPath ?? "")")) {
      image in image.resizable()
    } placeholder: {
      ZStack {
        Text(movie.title)
          .opacity(0.2)
        ProgressView()
      }
      .foregroundColor(.white)
    }
    .frame(width: 48, height: 72)
  }
 
  var buttonText: String {isMovieInWatchList ? "Added" : "+ watchlist" }
  
  var buttonView: some View {
    Button(action: addMovieToWatchList ) {
      Text(buttonText.uppercased())
        .padding(8)
        .foregroundColor(isMovieInWatchList ? .BackgroundListView : .white.opacity(0.8))
        .font(.caption)
        .background(
          Group {
            if !isMovieInWatchList {
              RoundedRectangle(cornerRadius: 3)
                .stroke(.white, lineWidth: 2)
            } else {
              RoundedRectangle(cornerRadius: 3)
                .fill(.white.opacity(0.8))
            }
          }
        )
      }
    .disabled(isMovieInWatchList)
  }
  
  var body: some View {
    HStack {
      NavigationLink(value: movie) {
        imageView
        Text(movie.title)
          .multilineTextAlignment(.leading)
        Spacer()
      }
      buttonView
    }
    .foregroundColor(.white)
    .padding()
  }
}

struct SearchListCell_Previews: PreviewProvider {
    static var previews: some View {
      SearchListCell(
        movie: .antMan,
        isMovieInWatchList: false,
        addMovieToWatchList: { print("add") }
      )
      .background(Color.BackgroundListView)
    }
}

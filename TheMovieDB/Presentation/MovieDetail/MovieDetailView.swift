//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//

import SwiftUI

struct MovieDetailView: View {
  let movie: Movie
  let addToWatchList: () -> Void
  let removeFromWatchList: () -> Void
  let isOnWatchList: Bool
  
 
  var image: some View {
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
    .frame(width: 150, height: 230)
  }
  
  var title: some View {
    VStack {
      Text(movie.title)
        .font(.title)
        .bold()
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
      Text(movie.releaseDate)
        .foregroundColor(.white)
    }
  }
  
  func buttonAction() {
    if isOnWatchList {
      removeFromWatchList()
    } else {
      addToWatchList()
    }
  }
  
  var buttonText: String {
    isOnWatchList ? "Remove from watchlist" : "Add to watchlist"
  }
  
  
  var button: some View {
    Button(action: buttonAction) {
      Text(buttonText.uppercased())
        .font(.headline)
        .fontWeight(.heavy)
        .bold()
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 100)
            .stroke(.white, lineWidth: 3)
        )
        .foregroundColor(.white)
    }
  }
  
  var overView: some View {
    HStack {
      VStack (alignment: .leading, spacing: 12){
        Text("Overview".uppercased())
          .bold()
        Text(movie.overview)
          .lineSpacing(8)
      }
      .foregroundColor(.white)
      Spacer()
    }
  }
  
    var body: some View {
      ScrollView {
        VStack {
          image
          title
          button
          overView
         Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .background(Color.BackgroundListView)
      .navigationBarTitleDisplayMode(.inline)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
      MovieDetailView(
        movie: .avatar,
        addToWatchList: { print("Add to watchlist") },
        removeFromWatchList: { print("Remove from watchlist") },
        isOnWatchList: false
      )
    }
}

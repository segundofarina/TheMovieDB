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
  
  var scale: CGFloat {
    max(min(2 - offset, 2), 1)
  }
  
  var image: some View {
    VStack {
      Spacer()
      CacheAsyncImage(url: "https://image.tmdb.org/t/p/w300/\(movie.posterPath ?? "")")
        .frame(width: scale * 150 , height: scale * 230 )
    }
    .frame(width: 2 * 150 , height: 2 * 230 )
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
        .font(.subheadline)
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
  
  @State var offset: Double = 0
  
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
      .background(GeometryReader { proxy -> Color in
        DispatchQueue.main.async {
          offset = (-proxy.frame(in: .named("scroll")).origin.y / 180)
        }
        return Color.clear
      })
    }
    .coordinateSpace(name: "scroll")
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

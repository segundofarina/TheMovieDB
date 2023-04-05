//
//  SearchListViewRepresentable.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 23/03/2023.
//

import SwiftUI
struct PreviewDelegate: SearchListViewDelegate {
  let movies: [Movie] = [.antMan, .avatar, .blackPanther, .creed]
}

extension SearchViewModel: SearchListViewDelegate {
  var movies: [Movie] {
    self.searchedResults
  }
}

struct SearchListViewRepresentable: UIViewControllerRepresentable {
  @ObservedObject var vm: SearchViewModel
  
  func updateUIViewController(_ uiViewController: SearchListUIViewController, context: Context) {
    
  }
  func makeUIViewController(context: Context) -> SearchListUIViewController {
    
    let searchListViewController = SearchListUIViewController(vm: vm)
    
    return searchListViewController
  }
}

//struct SearchListViewRepresentable_Previews: PreviewProvider {
//
//  static var previews: some View {
//    SearchListViewRepresentable(vm: PreviewDelegate())
//      .background(Color.BackgroundListView)
//  }
//}

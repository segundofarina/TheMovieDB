//
//  SearchListUIViewController.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 23/03/2023.
//

import UIKit
import Combine

class SearchListUIViewController: UIViewController {
  let vm: SearchViewModel
  
  var searchListView: SearchListUIView!
  
  var cancellables = Set<AnyCancellable>()
  
  init(vm: SearchViewModel) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    searchListView.updateMovies()
    suscribeToViewModel()
  }
  
  override func loadView() {
    searchListView = SearchListUIView(delegate: vm)
    self.view = searchListView
  }
  
  private func suscribeToViewModel() {
    vm.$searchedResults
      .receive(on: DispatchQueue.main)
      .sink { [weak self] movies in
        self?.searchListView.updateMovies()
        print("movies changed")
        print(movies.map {$0.title})
      }.store(in: &cancellables)
  }
  
  
}



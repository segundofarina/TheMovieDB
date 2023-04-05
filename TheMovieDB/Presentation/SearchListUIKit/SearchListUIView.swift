//
//  SearchListUIView.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 22/03/2023.
//

import UIKit
import SwiftUI

protocol SearchListViewDelegate {
  var movies: [Movie] { get }
}

class SearchListUIView: UIView {
  
  private var table: UITableView!
  
  private let delegate: SearchListViewDelegate
  
  init(delegate: SearchListViewDelegate) {
    self.delegate = delegate
    super.init(frame: .zero)
    setupTable()
    setupConstraints()
  }
  
  private func setupTable() {
    table = UITableView()
    table.register(SearchListUITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    table.allowsSelection = false
    table.dataSource = self
    table.delegate = self
    table.backgroundColor = UIColor(Color.BackgroundListView)
    addSubview(table)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    table.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      table.topAnchor.constraint(equalTo: topAnchor),
      table.trailingAnchor.constraint(equalTo: trailingAnchor),
      table.bottomAnchor.constraint(equalTo: bottomAnchor),
      table.leadingAnchor.constraint(equalTo: leadingAnchor)
    ])
  }
  
  func updateMovies() {
    table.reloadData()
  }
  
}

extension SearchListUIView: UITableViewDelegate {
  
}

extension SearchListUIView: UITableViewDataSource {
  
  static private let cellIdentifier = "search_cell"
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    delegate.movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath) as! SearchListUITableViewCell
    cell.setMovie(movie: self.delegate.movies[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 96.0
  }
}

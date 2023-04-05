//
//  SearchListUITableViewCell.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 23/03/2023.
//

import UIKit
import Combine


class SearchListUITableViewCell: UITableViewCell {
  
  private var imageLoader: ImageLoader?
  
  private lazy var button: UIButton = {
    var button = UIButton()
    return button
  }()
  
  private lazy var movieImageView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  private lazy var title: UILabel = {
    let title = UILabel()
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    title.font = .systemFont(ofSize: title.font.pointSize, weight: .bold)
    title.textColor = .white
    return title
  }()
  
  var cancellables = Set<AnyCancellable>()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(movieImageView)
    addSubview(title)
    addSubview(button)
    self.backgroundColor = .clear
    setUpConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpConstraints() {
    movieImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
      movieImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
      movieImageView.heightAnchor.constraint(equalToConstant: 72),
      movieImageView.widthAnchor.constraint(equalToConstant: 48)
    ])
    
    // Avoid compile constraint fraction error
    let constraint = movieImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
    constraint.priority = .defaultLow
    constraint.isActive = true

    
    title.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      title.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 8),
      title.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
      title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
     
    ])
    
    button.setContentHuggingPriority(.required, for: .horizontal)
    button.setContentCompressionResistancePriority(.required, for: .horizontal)
    
  
  }
  
  override func prepareForReuse() {
    cancellables.removeAll()
    movieImageView.image = nil
  }
  
  func setMovie(movie: Movie) {
    self.title.text = movie.title
    self.button.setTitle("+ Add", for: .normal)
    self.imageLoader = ImageLoader(url:"https://image.tmdb.org/t/p/w300/\(movie.posterPath ?? "")")
    self.imageView?.image = UIImage(systemName: "loading")
    imageLoader?.fetch()
    
    imageLoader?.$image.sink { [weak self] image in
      self?.movieImageView.image = image
    }
    .store(in: &cancellables)
  }
}

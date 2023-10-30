//
//  MovieDetailVC.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

import UIKit

class MovieDetailVC: BaseVC {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK: - Public properties
    
    var viewModel: MovieDetailVM?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.loadMovie()
        self.initUI()
    }
    
    // MARK: - Private method
    
    private func initUI() {
        self.title = Localize().get("movie_detail_title")
    }
    
    private func loadAsyncImage(imagePosterUrl: String) {
        if let imageURL = URL(string: Constants.API.imagesBaseUrl + imagePosterUrl) {
            let task = URLSession.shared.dataTask(with: imageURL) { [weak self] (data, _, error) in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            }
            task.resume()
        }
    }
    
}

// MARK: - MovieListVMOutput

extension MovieDetailVC: MovieDetailVMOutput {
    
    func showMovieDetails(movie: MovieView) {
        DispatchQueue.main.async {
            self.titleLabel.text = movie.title
            let releaseDateValue = movie.releaseDate.isEmpty ? Localize().get("movie_no_date") : movie.releaseDate
            self.dateLabel.text = Localize().get("release_date") + releaseDateValue
            self.overviewLabel.text = movie.overview
           
            if let imagePosterData = movie.imagePosterData {
                self.posterImageView.image = UIImage(data: imagePosterData)
            } else {
                let moviePlaceholder = UIImage(named: Constants.Images.moviePlaceholder)
                self.posterImageView.image = moviePlaceholder
                self.loadAsyncImage(imagePosterUrl: movie.imagePosterUrl)
            }
        }
    }
}

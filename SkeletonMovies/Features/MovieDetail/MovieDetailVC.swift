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
    
}

// MARK: - MovieListVMOutput

extension MovieDetailVC: MovieDetailVMOutput {
    
    func showMovieDetails(movie: MovieView) {
        DispatchQueue.main.async {
            self.titleLabel.text = movie.title
            let releaseDateValue = movie.releaseDate.isEmpty ? Localize().get("movie_no_date") : movie.releaseDate
            self.dateLabel.text = Localize().get("release_date") + releaseDateValue
            self.overviewLabel.text = movie.overview
            let posterImage = UIImage(data: movie.imageData)
            self.posterImageView.image = posterImage
        }
    }
}

//
//  MovieTableViewCell.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Public method

    func bindData(movie: MovieView) {
        self.titleLabel.text = movie.title
        self.dateLabel.text = movie.releaseDate
        let posterImage = UIImage(data: movie.imageData)
        self.posterImageView.image = posterImage
    }
}


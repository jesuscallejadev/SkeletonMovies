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
        let moviePlaceholder = UIImage(named: Constants.Images.moviePlaceholder)
        self.posterImageView.image = moviePlaceholder
    }
    
    func loadAsyncImageData(imagePosterUrl: String, completion: @escaping (Data?) -> Void) {
        if let imageURL = URL(string: Constants.API.imagesBaseUrl + imagePosterUrl) {
            let task = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                completion(data)
            }
            task.resume()
        } else {
            LogWarn("Image url not valid: \(imagePosterUrl)")
            completion(nil)
        }
    }

    
}


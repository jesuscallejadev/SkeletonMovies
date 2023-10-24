//
//  MovieView.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 13/10/23.
//


import Foundation

struct MovieView {
    var title: String
    var releaseDate: String
    var imageData: Data
    let overview: String
    
    // MARK: - Constructors (DTO Data to View)
    
    init(movie: Movie.MovieResult, imageData: Data) {
        self.title = movie.title
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
        self.imageData = imageData
    }
}

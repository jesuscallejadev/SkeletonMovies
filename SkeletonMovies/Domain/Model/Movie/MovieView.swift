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
    let overview: String
    var imagePosterUrl: String
    var imagePosterData: Data?
    
    // MARK: - Constructors (DTO Data to View)
    
    init(movie: Movie.MovieResult) {
        self.title = movie.title
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
        self.imagePosterUrl = movie.posterPath
        self.imagePosterData = nil
    }
}

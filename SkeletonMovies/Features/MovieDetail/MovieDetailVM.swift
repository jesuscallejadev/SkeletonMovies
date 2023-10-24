//
//  MovieDetailVM.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

import Foundation

protocol MovieDetailVMOutput: AnyObject {
    func showMovieDetails(movie: MovieView)
}

protocol MovieDetailVMInput  {
    func loadMovie()
}

class MovieDetailVM {
    
    // MARK: - Public Properties
    
    weak var output : MovieDetailVMOutput?
    
    // MARK: - Private properties
    
    private let navigation: MoviesNavigationInput
    private let movie: MovieView
    
    // MARK: - Constructor
    
    init(navigation: MoviesNavigationInput, movie: MovieView) {
        self.navigation = navigation
        self.movie = movie
    }
}

// MARK: - MovieDetailVMInput

extension MovieDetailVM: MovieDetailVMInput {
    
    func loadMovie() {
        self.output?.showMovieDetails(movie: self.movie)
    }
}


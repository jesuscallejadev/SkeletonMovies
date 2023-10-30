//
//  MovieListVM.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 13/10/23.
//

import Foundation

protocol MovieListVMOutput: AnyObject {
    func updateViewProgress(show: Bool)
    func updateViewState(show: Bool, message: String)
    func showMovies(moviesList: [MovieView], filtered: Bool)
}

protocol MovieListVMInput {
    func getMovies()
    func getMoreMovies()
    func onMovieSearch(title: String)
    func onMovieSelected(movie: MovieView)
}

class MovieListVM {
    
    // MARK: - Public Properties
    
    weak var output : MovieListVMOutput?
    
    // MARK: - Private properties
    
    private let navigation: MoviesNavigationInput
    private let moviesInteractor: MoviesInteractorInput
    private var nextPage: String
    
    // MARK: - Constructor
    
    init(navigation: MoviesNavigationInput, moviesInteractor: MoviesInteractorInput) {
        self.navigation = navigation
        self.moviesInteractor = moviesInteractor
        self.nextPage = ""
    }
    
    private func loadMovies() {
        Task {
            await self.moviesInteractor.loadData(nextPage: self.nextPage)
        }
    }
    
    private func searchMovies(title: String) {
        Task {
            await self.moviesInteractor.onMovieSearch(title: title)
        }
    }
    
    private func loadMoreMovies() {
        if !self.nextPage.isEmpty {
            self.loadMovies()
        }
    }
    
    private func showMovieDetail(selectedMovie: MovieView) {
        self.navigation.showMovieDetail(movie: selectedMovie)
    }
}

// MARK: - MovieListVMInput

extension MovieListVM: MovieListVMInput {
    
    func getMovies() {
        self.loadMovies()
    }
    
    func getMoreMovies() {
        self.loadMoreMovies()
    }
    
    func onMovieSearch(title: String) {
        self.searchMovies(title: title)
    }
    
    func onMovieSelected(movie: MovieView) {
        self.showMovieDetail(selectedMovie: movie)
    }
}

// MARK: - MoviesInteractorOutput

extension MovieListVM: MoviesInteractorOutput {
    
    func updateLoadingSpinner(show: Bool) {
        DispatchQueue.main.async {
            self.output?.updateViewProgress(show: show)
            self.output?.updateViewState(show: show, message: Localize().get("movies_list_loading"))
        }
    }
    
    func showMoviesList(moviesList: [MovieView], nextPage: String) {
        DispatchQueue.main.async {
            self.nextPage = nextPage
            self.output?.showMovies(moviesList: moviesList, filtered: false)
        }
    }
    
    func showFilteredMoviesList(moviesList: [MovieView]) {
        DispatchQueue.main.async {
            self.output?.showMovies(moviesList: moviesList, filtered: true)
        }
    }
    
    func onEmptyMovies() {
        DispatchQueue.main.async {
            self.output?.updateViewState(show: true, message: Localize().get("movies_list_empty"))
        }
    }
    
    func noInternetConnection() {
        DispatchQueue.main.async {
            self.output?.updateViewProgress(show: false)
            self.output?.updateViewState(show: true, message: Localize().get("no_internet_connection"))
        }
    }
    
}

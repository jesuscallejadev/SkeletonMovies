//
//  MoviesInteractor.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 13/10/23.
//

import Foundation

protocol MoviesInteractorOutput: AnyObject {
    func updateLoadingSpinner(show: Bool)
    func showMoviesList(moviesList: [MovieView], nextPage: String)
    func showFilteredMoviesList(moviesList: [MovieView])
    func onEmptyMovies()
    func noInternetConnection()
}

extension MoviesInteractorOutput {
    func updateLoadingSpinner(show: Bool) {}
    func showMoviesList(moviesList: [Movie], nextPage: String) {}
    func onEmptyMovies() {}
    func noInternetConnection() {}
}

protocol MoviesInteractorInput {
    func loadData(nextPage: String)
    func onMovieSearch(title: String)
}

class MoviesInteractor {
    
    // MARK: - Public Properties
    
    weak var output: MoviesInteractorOutput?
    
    // MARK: - Private properties
    
    private let services: ServicesManagerInput
    private var currentPage: Int = Constants.API.startPage
    
    // MARK: - Init
    
    init(services: ServicesManagerInput) {
        self.services = services
    }
    
    // MARK: - Private methods
    
    private func loadMovies(nextPage: String) {
        LogInfo("Load Movies")
        self.output?.updateLoadingSpinner(show: true)
        self.recoverMovies(nextPage: nextPage)
    }
    
    private func recoverMovies(nextPage: String) {
        var queryParams: [String: String]? = nil
        if !nextPage.isEmpty {
            queryParams = [
                Constants.API.page: nextPage
            ]
        }
        self.services.launchRequest(
            url: Constants.API.moviesBaseUrl + Constants.API.getMoviesEndpoint,
            method: .get,
            header: [
                Constants.API.token: Constants.API.userTokenValue,
            ],
            queryParams: queryParams,
            requiresRefresh: true
        ) { [weak self] result in
            switch result {
            case .success(let json):
                self?.output?.updateLoadingSpinner(show: false)
                self?.parseMoviesList(json: json)
                
            case .error(let error):
                switch error.type {
                case .noInternetcConnection:
                    self?.output?.noInternetConnection()
                default:
                    LogWarn("Error recovering movies: \(error.text)")
                }
            }
        }
    }
    
    private func searchMovies(title: String) {
        var queryParams: [String: String]? = nil
        queryParams = [
            Constants.API.query: title
        ]
        
        self.services.launchRequest(
            url: Constants.API.moviesBaseUrl + Constants.API.searchMoviesEndpoint,
            method: .get,
            header: [
                Constants.API.token: Constants.API.userTokenValue,
            ],
            queryParams: queryParams,
            requiresRefresh: true
        ) { [weak self] result in
            switch result {
            case .success(let json):
                self?.output?.updateLoadingSpinner(show: false)
                self?.parseMoviesList(json: json, filtered: true)
                
            case .error(let error):
                switch error.type {
                case .noInternetcConnection:
                    self?.output?.noInternetConnection()
                default:
                    LogWarn("Error recovering movies: \(error.text)")
                }
            }
        }
    }
    
    private func parseMoviesList(json: Any, filtered: Bool = false) {
        if let data = json as? [String: Any], let movie = Movie(data: data) {
            LogInfo("Total pages: \(movie.totalPages)")
            
            if movie.results.isEmpty {
                self.output?.onEmptyMovies()
            } else {
                var moviesList = [MovieView]()
                let group = DispatchGroup()
                
                for result in movie.results {
                    moviesList.append(MovieView(movie: result))
                }
                
                if filtered {
                    self.output?.showFilteredMoviesList(moviesList: moviesList)
                } else {
                    self.updatePagination(moviesList: moviesList)
                }
            }
        }
    }
    
    private func updatePagination(moviesList: [MovieView]) {
        var nextPage = ""
        if self.currentPage < Constants.API.endPage {
            self.currentPage += 1
            nextPage = String(self.currentPage)
        }
        self.output?.showMoviesList(moviesList: moviesList, nextPage: nextPage)
    }
    
}


// MARK: - MoviesInteractorInput

extension MoviesInteractor: MoviesInteractorInput {
    
    func loadData(nextPage: String) {
        self.loadMovies(nextPage: nextPage)
    }
    
    func onMovieSearch(title: String) {
        self.searchMovies(title: title)
    }
}


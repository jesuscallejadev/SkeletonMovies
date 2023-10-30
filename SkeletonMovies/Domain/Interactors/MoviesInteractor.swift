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
    func showMoviesList(moviesList: [MovieView], nextPage: String) {}
    func onEmptyMovies() {}
    func noInternetConnection() {}
}

protocol MoviesInteractorInput {
    func loadData(nextPage: String) async
    func onMovieSearch(title: String) async
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
    
    private func loadMovies(nextPage: String) async {
        LogInfo("Load Movies")
        self.output?.updateLoadingSpinner(show: true)
        await recoverMovies(nextPage: nextPage)
    }
    
    private func recoverMovies(nextPage: String) async {
        var queryParams: [String: String]? = nil
        if !nextPage.isEmpty {
            queryParams = [
                Constants.API.page: nextPage
            ]
        }

        do {
            let data = try await services.launchRequest(
                url: Constants.API.moviesBaseUrl + Constants.API.getMoviesEndpoint,
                method: .get, body: nil,
                header: [
                    Constants.API.token: Constants.API.userTokenValue,
                ],
                queryParams: queryParams,
                requiresRefresh: true
            )

            self.parseMoviesList(json: data)
        } catch {
            if let serviceError = error as? ServiceError {
                switch serviceError.type {
                case .noInternetcConnection:
                    self.output?.noInternetConnection()
                default:
                    LogWarn("Error recovering movies: \(serviceError.localizedDescription)")
                }
            } else {
                LogWarn("Error recovering movies: \(error.localizedDescription)")
            }
        }
    }
    
    private func searchMovies(title: String) async {
        var queryParams: [String: String]? = nil
        queryParams = [
            Constants.API.query: title
        ]

        do {
            let data = try await services.launchRequest(
                url: Constants.API.moviesBaseUrl + Constants.API.searchMoviesEndpoint,
                method: .get, body: nil,
                header: [
                    Constants.API.token: Constants.API.userTokenValue,
                ],
                queryParams: queryParams,
                requiresRefresh: true
            )

            self.parseMoviesList(json: data)
            
        } catch {
            if let serviceError = error as? ServiceError {
                switch serviceError.type {
                case .noInternetcConnection:
                    self.output?.noInternetConnection()
                default:
                    LogWarn("Error recovering movies: \(serviceError.localizedDescription)")
                }
            } else {
                LogWarn("Error recovering movies: \(error.localizedDescription)")
            }
        }
    }

    
    private func parseMoviesList(json: Data, filtered: Bool = false) {
        do {
            let decoder = JSONDecoder()
            let moviesData = try decoder.decode(MoviesData.self, from: json)
            
            if moviesData.results.isEmpty {
                self.output?.onEmptyMovies()
            } else {
                var moviesList = [MovieView]()
                
                for result in moviesData.results {
                    moviesList.append(MovieView(movie: result))
                }
                
                self.output?.updateLoadingSpinner(show: false)
                
                if filtered {
                    self.output?.showFilteredMoviesList(moviesList: moviesList)
                } else {
                    self.updatePagination(moviesList: moviesList)
                }
            }
            
        } catch {
            LogWarn("Error decoding JSON: \(error)")
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
    
    func loadData(nextPage: String) async {
        await self.loadMovies(nextPage: nextPage)
    }
    
    func onMovieSearch(title: String) async {
        await self.searchMovies(title: title)
    }
}


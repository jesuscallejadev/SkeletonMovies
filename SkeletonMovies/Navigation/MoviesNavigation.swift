//
//  MoviesNavigation.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import UIKit

protocol MoviesNavigationInput {
    func showMovieList(nav: UINavigationController)
    func showMovieDetail(movie: MovieView)
}

class MoviesNavigation {
    
    var navigationController: UINavigationController?
    
    // MARK: - Private method
    
    private func getMovieListVC() -> MovieListVC? {
        let storyboard = UIStoryboard(name: Constants.StoryBoardIds.moviesList, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIds.moviesListVC) as? MovieListVC else { return nil }
        
        let services = ServicesManager()
        let moviesInteractor = MoviesInteractor(services: services)
        
        let viewModel = MovieListVM(navigation: self, moviesInteractor: moviesInteractor)
        moviesInteractor.output = viewModel
        viewModel.output = controller
        controller.viewModel = viewModel
        return controller
    }
    
    private func getMovieDetailsVC(movie: MovieView) -> MovieDetailVC? {
        let storyboard = UIStoryboard(name: Constants.StoryBoardIds.movieDetail, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIds.movieDetailVC) as? MovieDetailVC else { return nil }
        
        let viewModel = MovieDetailVM(navigation: self, movie: movie)
        viewModel.output = controller
        controller.viewModel = viewModel
        return controller
    }
}

// MARK: - SplashNavigationInput

extension MoviesNavigation: MoviesNavigationInput {
    
    func showMovieList(nav: UINavigationController) {
        self.navigationController = nav
        guard let movieListVC = self.getMovieListVC() else { return LogWarn("MovieListVC is nil") }
        self.navigationController?.show(movieListVC, sender: self)
    }
    
    func showMovieDetail(movie: MovieView) {
        self.navigationController?.topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.topViewController?.navigationController?.isNavigationBarHidden = false
        guard let movieDetailVC = self.getMovieDetailsVC(movie: movie) else { return LogWarn("MovieDetailsVC is nil") }
        self.navigationController?.show(movieDetailVC, sender: nil)
    }
}

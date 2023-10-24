//
//  AppNavigation.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//


import Foundation
import UIKit

protocol AppNavigationInput {
    func showSplash()
    func showOnboarding()
    func showMovies()
}

class AppNavigation {
    
    var window: UIWindow?
    var navigationController = MainNavigationController()
}


// MARK: - AppNavigationInput

extension AppNavigation: AppNavigationInput {
    
    func showSplash() {
        self.navigationController.setNavigationBarHidden(true, animated: false)
        let splashNavigation = SplashNavigation()
        splashNavigation.showSplash(nav: self.navigationController)
        self.window?.rootViewController = self.navigationController
    }
    
    func showOnboarding() {
        if self.navigationController.viewControllers.count > 0 {
            self.navigationController.viewControllers.removeAll()
        }
        self.navigationController.view.backgroundColor = .black
        self.navigationController.setNavigationBarHidden(true, animated: false)
        let onboardingNavigation = OnboardingNavigation()
        onboardingNavigation.showOnboarding(nav: self.navigationController)
    }
    
    func showMovies() {
        if self.navigationController.viewControllers.count > 0 {
            self.navigationController.viewControllers.removeAll()
        }
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.view.backgroundColor = .black
        let moviesNavigation = MoviesNavigation()
        moviesNavigation.showMovieList(nav: self.navigationController)
    }
    
}


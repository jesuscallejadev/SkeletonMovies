//
//  SplashNavigation.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import Foundation
import UIKit

protocol SplashNavigationInput {
    func showSplash(nav: UINavigationController)
    func showOnboarding()
    func showMovies()
}

class SplashNavigation {
    
    var navigationController: UINavigationController?
    
    // MARK: - Private method
    
    private func getSplashVC() -> SplashVC? {
        let storyboard = UIStoryboard(name: Constants.StoryBoardIds.splash, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIds.splashVC) as? SplashVC else { return nil }
        
        let userDefaultManager = UserDefaultManager()
        let splashInteractor = SplashInteractor(userDefaultManager: userDefaultManager)
        
        let viewModel = SplashVM(navigation: self, splashInteractor: splashInteractor)
        splashInteractor.output = viewModel
        viewModel.output = controller
        controller.viewModel = viewModel
        return controller
    }
}

// MARK: - SplashNavigationInput

extension SplashNavigation: SplashNavigationInput {
    
    func showSplash(nav: UINavigationController) {
        self.navigationController = nav
        guard let splashVC = self.getSplashVC() else { return LogWarn("SplashVC is nil") }
        self.navigationController?.viewControllers = [splashVC]
    }
    
    func showOnboarding() {
        guard let navigation = self.navigationController as? MainNavigationController else {
            LogWarn("Main Navigation is nil")
            return
        }
        
        let appNavigation = AppNavigation()
        appNavigation.navigationController = navigation
        appNavigation.showOnboarding()
    }
    
    func showMovies() {
        guard let navigation = self.navigationController as? MainNavigationController else {
            LogWarn("Main Navigation is nil")
            return
        }
        
        let appNavigation = AppNavigation()
        appNavigation.navigationController = navigation
        appNavigation.showMovies()
    }
}



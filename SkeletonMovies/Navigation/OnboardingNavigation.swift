//
//  OnboardingNavigation.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 13/10/23.
//

import UIKit


protocol OnboardingNavigationInput {
    func showOnboarding(nav: UINavigationController)
    func showMovieList()
}

class OnboardingNavigation {
    
    var navigationController: UINavigationController?
    
    // MARK: - Private method
    
    private func getOnboardingVC() -> PageVC? {
        let storyboard = UIStoryboard(name: Constants.StoryBoardIds.onboarding, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIds.pageVC) as? PageVC else { return nil }
        
        let userDefaultManager = UserDefaultManager()
        let viewModel = PageVM(navigation: self, userDefaultManager: userDefaultManager)
        controller.viewModel = viewModel
        
        return controller
    }
}

// MARK: - SplashNavigationInput

extension OnboardingNavigation: OnboardingNavigationInput {
    
    func showOnboarding(nav: UINavigationController) {
        self.navigationController = nav
        guard let onboardingVC = self.getOnboardingVC() else { return LogWarn("OnboardingVC is nil") }
        self.navigationController?.show(onboardingVC, sender: self)
    }
    
    func showMovieList() {
        guard let navigation = self.navigationController as? MainNavigationController else {
            LogWarn("Main Navigation is nil")
            return
        }
        
        let appNavigation = AppNavigation()
        appNavigation.navigationController = navigation
        appNavigation.showMovies()
    }
}



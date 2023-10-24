//
//  SplashVM.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import Foundation

protocol SplashVMOutput: AnyObject {}

protocol SplashVMInput  {
    func launchApp()
}

class SplashVM {
    
    // MARK: - Public Properties
    
    weak var output : SplashVMOutput?
    
    // MARK: - Private properties
    
    private let navigation: SplashNavigationInput
    private let splashInteractor: SplashInteractorInput
    
    // MARK: - Constructor
    
    init(navigation: SplashNavigationInput, splashInteractor: SplashInteractorInput) {
        self.navigation = navigation
        self.splashInteractor = splashInteractor
    }
}

// MARK: - SplashVMInput

extension SplashVM: SplashVMInput {
    
    func launchApp() {
        self.splashInteractor.checkIsNewUser()
    }
}

// MARK: - SplashInteractorOutput

extension SplashVM: SplashInteractorOutput {
    
    func showOnboarding() {
        self.navigation.showOnboarding()
    }
    
    func showMovies() {
        self.navigation.showMovies()
    }
}


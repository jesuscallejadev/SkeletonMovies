//
//  SplashInteractor.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import Foundation

protocol SplashInteractorOutput {
    func showOnboarding()
    func showMovies()
}

protocol SplashInteractorInput {
    func checkIsNewUser()
}

class SplashInteractor {
    
    // MARK: - Public Properties
    
    var output: SplashInteractorOutput?
    
    // MARK: - Private properties
    
    private let userDefaultManager: UserDefaultManagerInput
    
    // MARK: - Constructor
    
    init(userDefaultManager: UserDefaultManagerInput) {
        self.userDefaultManager = userDefaultManager
    }
    
    private func checkOnboardingFlag() {
        
        let onboardingFlagCheck = self.userDefaultManager.onboardingFlagCheck()
        if onboardingFlagCheck {
            self.output?.showMovies()
        } else {
            self.output?.showOnboarding()
        }
        
    }
}

// MARK: - SplashInteractorInput

extension SplashInteractor: SplashInteractorInput {
    
    func checkIsNewUser() {
        self.checkOnboardingFlag()
    }
}


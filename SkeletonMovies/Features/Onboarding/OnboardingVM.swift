//
//  OnboardingVM.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import Foundation

protocol OnboardingVMOutput: AnyObject {
    func updateButtonStatus(show: Bool)
}

protocol OnboardingVMInput {
    func onViewWillAppear(id: String)
    func onStartTapped()
}

class OnboardingVM {
    
    // MARK: - Public Properties
    
    weak var output : OnboardingVMOutput?
    
    // MARK: - Private properties
    
    private let navigation: OnboardingNavigationInput
    private let userDefaultManager: UserDefaultManagerInput
    
    // MARK: - Constructor
    
    init(navigation: OnboardingNavigationInput, userDefaultManager: UserDefaultManagerInput) {
        self.navigation = navigation
        self.userDefaultManager = userDefaultManager
    }
    private func enableOnboardingFlag() {
        self.userDefaultManager.enableOnboardingFlag()
        self.showMovies()
    }
    
    private func showMovies() {
        self.navigation.showMovieList()
    }
}

// MARK: - OnboardingVMInput

extension OnboardingVM: OnboardingVMInput {
    
    func onViewWillAppear(id: String) {
        self.output?.updateButtonStatus(show: id == Constants.OnboardingIds.onboardingIdThird)
    }
    
    func onStartTapped() {
        self.enableOnboardingFlag()
    }
}


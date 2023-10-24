//
//  UserDefaultsManager.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 24/10/23.
//

import Foundation

protocol UserDefaultManagerInput {
    func onboardingFlagCheck() -> Bool
    func enableOnboardingFlag()
}

// MARK: - UserDefaultManagerInput

struct UserDefaultManager: UserDefaultManagerInput {
    
    // MARK: - Private porperties
    
    private let onboardingFlagKey: String
    
    init(onboardingFlagKey: String = Constants.OnboardingIds.onboardingFlag) {
        self.onboardingFlagKey = onboardingFlagKey
    }
    
    func enableOnboardingFlag() {
        UserDefaults.standard.set(true, forKey: self.onboardingFlagKey)
    }

    func onboardingFlagCheck() -> Bool {
        return UserDefaults.standard.bool(forKey: self.onboardingFlagKey)
    }
}



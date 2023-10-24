//
//  AppController.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import Foundation

 protocol AppControllerInput {
    func startApp()
}

class AppController {
    
    // MARK: - Singleton
    
    static let shared = AppController()
    
    // MARK: - Public properties
    
    var appNavigation: AppNavigation?
}

// MARK: - AppControllerInput

extension AppController: AppControllerInput {
    
    func startApp() {
        // MARK: Setup Logger
        LogManager.shared.logLevel = .debug
        LogManager.shared.logStyle = .funny
        self.appNavigation?.showSplash()
    }
}

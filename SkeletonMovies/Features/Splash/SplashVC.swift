//
//  SplashVC.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import UIKit

class SplashVC: BaseVC {
    
    // MARK: - Public properties
    
    var viewModel: SplashVM?
    
    // MARK: - Life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.launchApp()
    }
}

// MARK: - SplashVMOutput

extension SplashVC: SplashVMOutput {}

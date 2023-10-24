//
//  PageVM.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 13/10/23.
//

import Foundation
import UIKit

public class PageVM {
    
    // MARK: - Private properties
    
    private let navigation: OnboardingNavigationInput
    private let userDefaultManager: UserDefaultManagerInput
    
    // MARK: - Constructor
    
    init(navigation: OnboardingNavigationInput, userDefaultManager: UserDefaultManagerInput) {
        self.navigation = navigation
        self.userDefaultManager = userDefaultManager
    }
    
    func getViewController(forViewController vc: UIViewController, isNextController: Bool) -> UIViewController? {
        guard let vc = vc as? OnboardingVC else { return nil }
        var index: Int = 0
        for (location, scene) in OnboardingContent.onboardingScenes.enumerated() {
            if scene.id == vc.id {
                index = location
            }
        }
        isNextController ? (index += 1) : (index -= 1)
        if isNextController {
            if OnboardingContent.onboardingScenes.count > index {
                return createSlideViewController(fromIndex: index)
            }else{
                return nil
            }
        }else{
            if index >= 0 {
                return createSlideViewController(fromIndex: index)
            }else{
                return nil
            }
        }
    }
    
    func createSlideViewController(fromIndex index: Int) -> UIViewController {
        let screen = OnboardingContent.onboardingScenes[index]
        let viewController = UIStoryboard(name: screen.storyBoardName, bundle: nil).instantiateViewController(identifier: screen.viewControllerName)
        (viewController as? OnboardingVC)?.id = screen.id
        (viewController as? OnboardingVC)?.animationName = screen.animationName
        (viewController as? OnboardingVC)?.titleText = screen.mainTitle
        let viewModel = OnboardingVM(navigation: navigation, userDefaultManager: self.userDefaultManager)
        (viewController as? OnboardingVC)?.viewModel = viewModel
        viewModel.output = (viewController as? OnboardingVC)
        return viewController
    }
    
}


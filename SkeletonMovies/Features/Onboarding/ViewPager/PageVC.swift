//
//  PageVC.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 13/10/23.
//

import UIKit

class PageVC: UIPageViewController {
    
    var viewModel: PageVM?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .appSecondaryColor
        self.setupPageControl()
        self.dataSource = self
        self.delegate = self
        self.setViewControllers([self.viewModel?.createSlideViewController(fromIndex: 0) ?? UIViewController()], direction: .forward, animated: true)
    }
    
    func setupPageControl(){
        UIPageControl.appearance(whenContainedInInstancesOf: [PageVC.self]).currentPageIndicatorTintColor =  UIColor.white
        UIPageControl.appearance(whenContainedInInstancesOf: [PageVC.self]).pageIndicatorTintColor = UIColor.black
        UIPageControl.appearance(whenContainedInInstancesOf: [PageVC.self]).backgroundColor = UIColor.white
        UIPageControl.appearance(whenContainedInInstancesOf: [PageVC.self]).backgroundColor = UIColor.appSecondaryColor
    }
}

// MARK: - UIPageViewController Delegates

extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return OnboardingContent.onboardingScenes.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        var index: Int = 0
        for (location, scene) in OnboardingContent.onboardingScenes.enumerated() {
            if let vc = pageViewController.children.first as? OnboardingVC, vc.id == scene.id {
                index = location
            }
        }
        return index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        self.viewModel?.getViewController(forViewController: viewController, isNextController: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        self.viewModel?.getViewController(forViewController: viewController, isNextController: true)
    }
    
}

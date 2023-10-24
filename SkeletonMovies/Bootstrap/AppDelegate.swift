//
//  AppDelegate.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 12/10/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appController = AppController.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        
        self.startApp()
        
        return true
    }
    
    func startApp() {
        
        // MARK: Setup AppController
        
        // AppController
        self.appController.appNavigation = AppNavigation()
        self.appController.appNavigation?.window = self.window
        self.appController.startApp()
    }
    
    


}


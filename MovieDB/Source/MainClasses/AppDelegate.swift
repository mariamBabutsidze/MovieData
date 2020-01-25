//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    private func setupWindow()
    {
        if(self.window != nil)
        {
            return
        }
        
        self.window = UIWindow()
        
        let movieList = MovieListViewController.load(with: MovieListViewModel())
        
        let nav = MovieNavigationController.init(rootViewController: movieList)
        
        self.window?.rootViewController = nav
        
        self.window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupWindow()
        
        return true
    }
}


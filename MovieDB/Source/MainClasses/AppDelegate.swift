//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit
import Reachability
import LGSideMenuController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var connection = true
    private var reachability: Reachability?

    private func setupWindow()
    {
        if(self.window != nil)
        {
            return
        }
        
        self.window = UIWindow()
        
        let movieList = MovieListViewController.load(with: MovieListViewModel())
        
        let nav = MovieNavigationController.init(rootViewController: movieList)
        
        let sideMenu = LGSideMenuController(rootViewController: nav)
        sideMenu.view.backgroundColor = UIColor.MovieDB.darkGrey
        sideMenu.leftViewPresentationStyle = .scaleFromBig
        sideMenu.leftViewWidth = 200 * Constants.ScreenFactor
        let leftViewController = FilterViewController.load(with: FilterViewModel())
        leftViewController.delegate = movieList
        sideMenu.leftViewController = leftViewController
        self.window?.rootViewController = sideMenu
        
        self.window?.makeKeyAndVisible()
    }
    
    private func addReachability(){
        reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("sufh")
            change(connection: true)
            connection = true
        case .cellular:
            print("Reachable via Cellular")
            change(connection: true)
            connection = true
        case .unavailable:
            print("isjdf")
            change(connection: false)
            connection = false
        case .none:
            break
        }
    }
    
    private func change(connection: Bool){
        if self.connection != connection{
            if connection{
                if let nav = self.window?.rootViewController as? MovieNavigationController{
                    nav.popViewController(animated: false)
                }
            } else{
                let noInternet = NoInternetViewController.loadFromStoryboard()
                if let nav = self.window?.rootViewController as? MovieNavigationController{
                    nav.pushViewController(noInternet, animated: false)
                }
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupWindow()
        addReachability()
        return true
    }
}


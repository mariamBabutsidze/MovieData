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
import CoreData

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
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
            } else{
                let noInternet = NoInternetViewController.loadFromStoryboard()
                noInternet.modalPresentationStyle = .fullScreen
                self.window?.rootViewController?.present(noInternet)
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupWindow()
        addReachability()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MovieDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


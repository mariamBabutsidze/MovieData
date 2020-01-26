//
//  MovieNavigationController.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit
import RDExtensionsSwift

class MovieNavigationController: UINavigationController {
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.updateNavigationItems()
        
    }
    
    private func setupNavigationBar()
    {
        navigationBar.barTintColor = UIColor.black
        navigationBar.tintColor = UIColor.MovieDB.darkGrey
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.poppins(type: .semiBold, size: 14 * Constants.ScreenFactor)]
    }
    
    private func updateNavigationItems()
    {
        for i in 0 ..< self.viewControllers.count
        {
            let navigationItem = self.viewControllers[i].navigationItem
            navigationItem.setLeftBarButton(backButtonItem(), animated: false)
        }
    }
    
    private func backButtonItem() -> UIBarButtonItem
    {
        let item = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backClicked(sender:)))
        return item
    }
    
}

//MARK: - UIGestureRecognizerDelegate
extension MovieNavigationController: UIGestureRecognizerDelegate {
}

// MARK: Actions
extension MovieNavigationController {
    
    @objc private func backClicked(sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }
}


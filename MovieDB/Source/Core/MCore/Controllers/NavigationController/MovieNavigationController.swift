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
        navigationBar.barTintColor = UIColor.MovieDB.lightGrey
        navigationBar.tintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.poppins(type: .semiBold, size: 14 * Constants.ScreenFactor)]
    }
    
    private func updateNavigationItems()
    {
        for i in 0 ..< self.viewControllers.count
        {
            let navigationItem = self.viewControllers[i].navigationItem
            navigationItem.setLeftBarButtonItems([i == 0 ? menuButtonItem() : backButtonItem(), self.titleItem(self.viewControllers[i].title)], animated: false)
        }
    }
    
    private func titleItem(_ title: String?) -> UIBarButtonItem
    {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.poppins(type: .bold, size: 15 * Constants.ScreenFactor)
        label.text = title
        return UIBarButtonItem(customView: label)
    }
    
    private func menuButtonItem() -> UIBarButtonItem
    {
        let item = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(self.menuClicked(sender:)))
        return item
    }
    
    @objc private func menuClicked(sender: UIBarButtonItem) {
        self.toggleLeftViewAnimated(self)
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


//
//  NoInternetViewController.swift
//  Biliki-Development
//
//  Created by Mariam Babutsidze on 11/6/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {
    
    private var completionBlock: (() -> Void)?
    private var cancelBlock: (() -> Void)?
    
    static func load(with completion: (() -> Void)?, cancelBlock: (() -> Void)?) -> Self{
        let vc = self.loadFromStoryboard()
        vc.completionBlock = completion
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func retryClicked(_ sender: Any) {

    }
    
}

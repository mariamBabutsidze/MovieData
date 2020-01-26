//
//  NotificationCenterManager.swift
//  LibertyLoyalty
//
//  Created by Giorgi Iashvili on 4/3/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    private class Keys {
        
        static let languageDidChange = "languageDidChange"
        static let favouriteChanged = "favouriteChanged"
    }
    
    static var languageDidChange: Notification.Name { get { return Notification.Name(Keys.languageDidChange) } }
    static var favouriteChanged: Notification.Name { get { return Notification.Name(Keys.favouriteChanged) } }
}

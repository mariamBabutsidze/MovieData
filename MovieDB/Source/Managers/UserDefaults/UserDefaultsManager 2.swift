//
//  UserDefaultsManager.swift
//  LibertyLoyalty
//
//  Created by Giorgi Iashvili on 4/3/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import Foundation

// MARK: - General
extension UserDefaults {
    
    class General {
        
        private class Key {
            
            static let language = "key_user_defaults_general_language"
            
        }
        
        static var language: String? { get { return UserDefaults.standard.object(forKey: Key.language) as? String } set { UserDefaults.standard.set(newValue, forKey: Key.language); UserDefaults.standard.synchronize() } }
        
    }
    
}

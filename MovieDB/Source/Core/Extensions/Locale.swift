//
//  Locale.swift
//
//  Created by Giorgi Iashvili on 28.12.17.
//  Copyright © 2017 Giorgi Iashvili. All rights reserved.
//

import Foundation

extension Locale {
    
    private struct Id {
        
        static let ka_GE = "ka_Ge"
        static let en_US_POSIX = "en_US_POSIX"
        static let ru_RU = "ru_RU"
        
    }
    
    static var georgian : Locale { get { return Locale(identifier: Id.ka_GE) } }
    
    static var en_US_POSIX: Locale { get { return Locale(identifier: Id.en_US_POSIX) } }
    
    static var russian : Locale { get { return Locale(identifier: Id.ru_RU) } }
    
    static var currentLocal : Locale { get { return Locale(identifier: kLanguage.current.rawValue) } }
    
}

//
//  Language.swift
//
//  Created by Giorgi Iashvili on 4/3/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import Foundation

enum kLanguage: String, CaseIterable {
    
    static var current: kLanguage
    {
        get { return kLanguage(rawValue: UserDefaults.General.language ?? .empty) ?? .eng }
        set { UserDefaults.General.language = newValue.rawValue; NotificationCenter.default.post(name: .languageDidChange, object: nil) }
    }
    
    case geo = "ka"
    case eng = "en"
    
    var title: String { get { return LocalString("kLanguage_" + self.toString) } }
    
    var apiLanguage: String
    {
        get
        {
            switch(self)
            {
            case .geo:
                return "ka"
            case .eng:
                return "en-US"
            }
        }
    }
    
    var locale: Locale
    {
        get
        {
            switch(self)
            {
            case .geo:
                return Locale.georgian
            case .eng:
                return Locale.en_US_POSIX
            }
        }
    }
    
}

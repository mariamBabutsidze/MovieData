//
//  Utilities.swift
//
//  Created by Giorgi Iashvili on 4/3/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import Foundation

func LocalString(_ key: String, language: String) -> String
{
    if let rp = Bundle.main.path(forResource: language, ofType: "lproj"),
        let value = Bundle(path: rp)?.localizedString(forKey: key, value: nil, table: nil)
    {
        return value
    }
    return key
}

func LocalString(_ key: String, language: kLanguage = kLanguage.current) -> String
{
    return LocalString(key, language: language.rawValue)
}

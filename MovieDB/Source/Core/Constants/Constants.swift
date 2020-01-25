//
//  OPConstants.swift
//  Oppa
//
//  Created by Giorgi Iashvili on 16.06.18.
//  Copyright © 2018 Giorgi Iashvili. All rights reserved.
//

import UIKit

struct Constants {
    
    static let ScreenFactor = UIScreen.main.bounds.width/375
    static let defzaultMobilePrefixId = "GE"
    static let maxAllowedFileSizeMBs = 6.0
    
    struct General {
        
        static let iOS = "iOS"
        static let deviceType = 1
        
    }
    
    struct Network {
        
        static var APIUrl: String
        {
            return "https://api.themoviedb.org/"
        }
        
    }
    
    struct Animation {
        
        static let DefaultDuration = 0.27
        
    }
    
    struct Regex {
        
        static let Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        static let MobileNumber = "^5[0-9]{8}"
        static let MobileNumberTyping = "^[0-9]{0,9}"
        static let Password = "^[0-9]{5}"
        static let SmsCode = "^[0-9]{4}"
        static let PersonalId = "^[0-9]{11}"
        static let PersonalIdTyping = "^[0-9]{0,11}"
        static let AnyValue = ".*"
        static let Numbers = "[0-9]*"
        static let Currency = "^[0-9]*(|\\.[0-9]{1,2})$"
        static let CurrencyTyping = "^[0-9]*(|\\.[0-9]{0,2})$"
        static let FebruaryMonthDays = "^([1-9]{1}|1[0-9]|2[0-8])$"
        static let CardMask = "[0-9]{4}"
        static let CardMaskTyping = "[0-9]{0,4}"
        static let CardCVCCode = "[0-9]{3}"
        static let CardCVCCodeTyping = "[0-9]{0,3}"
        
    }
    
    struct Currency {
        
        static let GEL = "₾"
        static let USD = "$"
        static let EUR = "€"
        
    }
    
    struct Date {
        
        static let cSharpFormat12Hour = "yyyy-MM-dd'T'hh:mm:ss"
        static let cSharpFormat24Hour = "yyyy-MM-dd'T'HH:mm:ss"
        
    }
    
}

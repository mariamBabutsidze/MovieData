//
//  Fonts.swift
//  LibertyLoyalty
//
//  Created by Giorgi Iashvili on 4/3/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum PoppinsType: String {
        
        case medium = "Poppins-Medium"
        case mediumItalic = "Poppins-MediumItalic"
        case regular = "Poppins-Regular"
        case bold = "Poppins-Bold"
        case boldItalic = "Poppins-BoldItalic"
        case extraBold = "Poppins-ExtraBold"
        case exxtraBoldItalic = "Poppins-ExtraBoldItalic"
        case black = "Poppins-Black"
        case blackItalic = "Poppins-BlackItalic"
        case extraLight = "Poppins-ExtraLight"
        case extraLightItalic = "Poppins-ExtraLightItalic"
        case italic = "Poppins-Italic"
        case light = "Poppins-Light"
        case lightItalic = "Poppins-LightItalic"
        case semiBold = "Poppins-SemiBold"
        case SemiBoldItalic = "Poppins-SemiBoldItalic"
        case thin = "Poppins-Thin"
        case thinItalic = "Poppins-ThinItalic"
    }
    
    static func poppins(type: PoppinsType, size: CGFloat) -> UIFont
    {
        return UIFont(name: type.rawValue, size: size)!
    }
    
}

//
//  Network+Headers.swift
//  LibertyLoyalty
//
//  Created by Giorgi Iashvili on 4/12/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import Foundation

extension Network {
    
    typealias Headers = Dictionary<String, String>
    
    static func headers(with headers: Headers = .default) -> Headers
    {
        var headers = headers
        headers[Key.Parsing.xLanguage] = kLanguage.current.rawValue
       // headers[Key.Parsing.deviceType] = Constants.General.deviceType.toString
        if let token = User.current?.accessToken, !token.isEmpty {
            headers[Key.Parsing.authorization] = "\(Key.Parsing.bearer)\(token)"
        }
        return headers
    }
    
}

extension Network.Headers {
    
    static var `default`: Network.Headers { get { return [:] } }
    static var empty: Network.Headers { get { return [:] } }
    
}

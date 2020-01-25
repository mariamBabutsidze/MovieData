//
//  Network+Body.swift
//  LibertyLoyalty
//
//  Created by Giorgi Iashvili on 4/12/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import Foundation

extension Network {
    
    typealias Body = Dictionary<String, Any>
    
    static func body(with body: Body = .default) -> Body
    {
        var body = body
        body[Key.Parsing.apiKey] = Constants.APIKeys.dbKey
        return body
    }
    
}

extension Network.Body {
    
    static var `default`: Network.Body { get { return [:] } }
    static var empty: Network.Body { get { return [:] } }
    
}

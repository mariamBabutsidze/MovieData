//
//  Network+Keys.swift
//
//  Created by Giorgi Iashvili on 21.08.17.
//  Copyright © 2017 Giorgi Iashvili. All rights reserved.
//

extension Network {
    
    struct Key {
        
        enum Coding: String, CodingKey {
            
            case data = "data"
            case success = "success"
            //case code = "resultCode"
            //case message = "errorMessage"
            case errors = "errors"
            case errorCode = "errorCode"
            
        }
        
        struct Parsing {
            static let xLanguage = "lang"
            static let authorization = "Authorization"
            static let bearer = "bearer "
            static let accept = "accept"
            static let contentType = "Content-Type"
            static let applicationJson = "application/json"
            static let apiKey = "api_key"
        }
        
        struct Url {
            
            static let APIUrl = Constants.Network.APIUrl

        }
        
    }
    
}

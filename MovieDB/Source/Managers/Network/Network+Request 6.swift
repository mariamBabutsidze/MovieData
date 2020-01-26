//
//  Network+Request.swift
//  LibertyLoyalty
//
//  Created by Giorgi Iashvili on 4/5/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import Alamofire

extension Network {
    
    static func request(url: String, path: String, headers: Headers = .default, body: Body = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil) -> DataRequest
    {
        let request = self.shared.alamofire.request(url + path, method: method, parameters: body, encoding: encoding ?? (method == .get || method == .delete ? URLEncoding.default : JSONEncoding.default), headers: headers)
        
        print("Url: " + (request.request?.url?.absoluteString ?? "-1"))
        print(headers)
        print(body)
        
        return request.validate(statusCode: Network.Status.kCode.successCodes.map { $0.rawValue })
    }
    
}

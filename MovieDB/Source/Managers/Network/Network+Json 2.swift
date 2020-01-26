//
//  Network+Json.swift
//
//  Created by Giorgi Iashvili on 25.01.17.
//  Copyright © 2017 Giorgi Iashvili. All rights reserved.
//

import Alamofire

// MARK: - Initialize Request
extension Network {
    
    private static func jsonRequest(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil) -> DataRequest
    {
        let url = url ?? Key.Url.APIUrl
        var headers = headers != nil ? self.headers(with: headers!) : .empty
        let body = body != nil ? self.body(with: body!) : .empty
        
        if(encoding == nil)
        {
            headers[Key.Parsing.contentType] = Key.Parsing.applicationJson
            headers[Key.Parsing.accept] = Key.Parsing.applicationJson
        }
        
        return self.request(url: url, path: path, headers: headers, body: body, method: method, encoding: encoding)
    }
    
}

// MARK: - Execute Request
extension Network {
    
    static func jsonRequest(request: DataRequest, anyResponse: AnyResponseBlock, fail: FailBlock)
    {
        request.responseJSON(queue: DispatchQueue(label: .uuid)) { response in
            let statusCode = response.response?.statusCode ?? -1
            print("Url: " + (response.response?.url?.absoluteString ?? "-1"))
            print("Status code: " + statusCode.toString)
            switch(response.result)
            {
            case .success(let value):
                print(value)
                DispatchQueue.main.async {
                    anyResponse?(response)
                }
            case .failure(let error):
                print(error)
                print(String(data: response.data ?? Data(), encoding: .utf8) ?? "")
                let status = Status(error: error, code: response.response?.statusCode, jsonData: response.data)
                DispatchQueue.main.async {
                    if status.code == .unauthorized,
                        let request = (request.request as NSURLRequest?)?.mutableCopy() as? NSMutableURLRequest
                    {
                 //       self.shared.handleUnauthorized(request: request, success: anyResponse, fail: fail)
                    }
                    else if status.code == .noInternetConnection, let request = (request.request as NSURLRequest?)?.mutableCopy() as? NSMutableURLRequest{
                        fail?(status)
                        
                    }
                    else
                    {
                        fail?(status)
                    }
                }
            }
        }
    }
}

// MARK: - Request Execute Overloads
extension Network {
    
    static func jsonRequest(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, anyResponse: AnyResponseBlock, fail: FailBlock)
    {
        DispatchQueue(label: .uuid).async {
            let request = self.jsonRequest(url: url, path: path, headers: headers, body: body, method: method, encoding: encoding)
            self.jsonRequest(request: request, anyResponse: anyResponse, fail: fail)
        }
    }
    
    static func jsonRequest(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, empty: EmptyBlock, fail: FailBlock)
    {
        self.jsonRequest(url: url, path: path, headers: headers, body: body, method: method, encoding: encoding, anyResponse: { response -> Void in
            DispatchQueue(label: .uuid).async {
                let status = Status.decode(from: response.data)
                if(status.code == .ok)
                {
                    DispatchQueue.main.async {
                        empty?()
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        fail?(status)
                    }
                }
            }
        }, fail: fail)
    }
    
    static func jsonRequest(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, data: DataBlock, fail: FailBlock)
    {
        self.jsonRequest(url: url, path: path, headers: headers, body: body, method: method, encoding: encoding, anyResponse: { response in
            DispatchQueue(label: .uuid).async {
     //           let status = Status.decode(from: response.data)
                if let d = response.data{
     //               status.code == .ok
                    DispatchQueue.main.async {
                        data?(d)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        fail?(Status.error)
                    }
                }
            }
        }, fail: fail)
    }
    
    static func jsonRequest(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, pureData: DataBlock, fail: FailBlock)
    {
        self.jsonRequest(url: url, path: path, headers: headers, body: body, method: method, encoding: encoding, anyResponse: { response in
            if let d = response.data
            {
                pureData?(d)
            }
            else
            {
                fail?(.error)
            }
        }, fail: fail)
    }
    
    static func jsonRequest<T: Decodable>(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, type: T.Type, userInfo: [CodingUserInfoKey: Any]? = nil, parseInDispatchQueue: DispatchQueue? = nil, success: ((T) -> Void)? = nil, fail: FailBlock)
    {
        self.jsonRequest(url: url, path: path, headers: headers, body: body, method: method, encoding: encoding, data: { data in
            DispatchQueue(label: .uuid).async {
                if let object = T.decode(from: data, userInfo: userInfo)
                {
                    DispatchQueue.main.async {
                        success?(object)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        fail?(.error)
                    }
                }
            }
        }, fail: fail)
    }
    
    static func jsonRequest(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, json: JsonBlock, fail: FailBlock)
    {
        self.jsonRequest(url: url, path: path, headers: headers, body: body, method: method, encoding: encoding, anyResponse: { response in
            DispatchQueue(label: .uuid).async {
                let status = Status.decode(from: response.data)
                if let j = status.json,
                    status.code == .ok
                {
                    DispatchQueue.main.async {
                        json?(j)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        fail?(status)
                    }
                }
            }
        }, fail: fail)
    }
    
    static func jsonRequest(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, pureJson: JsonBlock, fail: FailBlock)
    {
        self.jsonRequest(url: url, path: path, headers: headers, body: body, method: method, encoding: encoding, anyResponse: { response in
            DispatchQueue(label: .uuid).async {
                let status = Status(code: .ok, jsonData: response.value)
                if let j = status.json,
                    status.code == .ok
                {
                    DispatchQueue.main.async {
                        pureJson?(j)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        fail?(status)
                    }
                }
            }
        }, fail: fail)
    }
    
}

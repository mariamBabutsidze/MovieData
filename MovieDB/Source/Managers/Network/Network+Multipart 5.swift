//
//  Network+Multipart.swift
//
//  Created by Giorgi Iashvili on 27.01.17.
//  Copyright © 2017 Giorgi Iashvili. All rights reserved.
//

import Alamofire
import SwiftyJSON

// MARK: - Execute Request
extension Network {
    
    static func multipartUploadRequest(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, files: [MultipartFile], anyResponse: AnyResponseBlock, fail: FailBlock)
    {
        let url = url ?? Key.Url.APIUrl
        let headers = headers != nil ? self.headers(with: headers!) : .empty
        let body = body != nil ? self.body(with: body!) : .empty
        
        self.shared.alamofire.upload(multipartFormData: { MultipartFormData in
            for item in body
            {
                if let data = "\(item.value)".data(using: .utf8)
                {
                    MultipartFormData.append(data, withName: item.key)
                }
            }
            for file in files
            {
                MultipartFormData.append(file.data, withName: file.key, fileName: file.name, mimeType: file.type)
            }
        }, to: url + path, headers: headers, encodingCompletion: { result in
            switch(result)
            {
            case .success(let request, _, _):
                
                print("Url: " + (request.request?.url?.absoluteString ?? "-1"))
                print(headers)
                print(body)
                
                request.responseJSON { response in
                    
                    print("Url: " + (response.response?.url?.absoluteString ?? "-1"))
                    print("Status code: " + (response.response?.statusCode.toString ?? "-1"))
                    
                    switch(response.result)
                    {
                    case .success(let value):
                        print(value)
                        anyResponse?(response)
                    case .failure(let error):
                        print(error)
                        print(String(data: response.data ?? Data(), encoding: .utf8) ?? "")
                        let status = Status(error: error, code: response.response?.statusCode, jsonData: response.data)
                        if status.code == .unauthorized,
                            let request = (request.request as NSURLRequest?)?.mutableCopy() as? NSMutableURLRequest
                        {
                            //self.shared.handleUnauthorized(request: request, success: anyResponse, fail: fail)
                        }
                        else if status.code == .noInternetConnection, let request = (request.request as NSURLRequest?)?.mutableCopy() as? NSMutableURLRequest{
                            
                        }
                        else
                        {
                            fail?(status)
                        }
                    }
                }
            case .failure(let error):
                fail?(Status(error: error))
            }
        })
    }
    
}

// MARK: - Request Execute Overloads
extension Network {
    
    static func multipartUploadRequest(path: String, headers: Headers? = .default, body: Body? = .default, files: [MultipartFile], empty: EmptyBlock, fail: FailBlock)
    {
        self.multipartUploadRequest(path: path, headers: headers, body: body, files: files, anyResponse: { response in
            let status = Status.decode(from: response.data)
            if(status.code == .ok)
            {
                empty?()
            }
            else
            {
                fail?(status)
            }
        }, fail: fail)
    }
    
    static func multipartUploadRequest<T: Decodable>(url: String? = nil, path: String, headers: Headers? = .default, body: Body? = .default, files: [MultipartFile], type: T.Type, userInfo: [CodingUserInfoKey: Any]? = nil, success: ((T) -> Void)? = nil, fail: FailBlock)
    {
        self.multipartUploadRequest(path: path, body: body, files: files, anyResponse: { response in
            let status = Status.decode(from: response.data)
            let d = try? status.json?.rawData()
            if let object = T.decode(from: d, userInfo: userInfo)
            {
                success?(object)
            }
            else
            {
                fail?(.error)
            }
        }, fail: fail)
    }
    
    static func multipartUploadRequest(path: String, headers: Headers? = .default, body: Body? = .default, files: [MultipartFile], json: JsonBlock, fail: FailBlock)
    {
        self.multipartUploadRequest(path: path, headers: headers, body: body, files: files, anyResponse: { response in
            let status = Status.decode(from: response.data)
            if let j = status.json,
                status.code == .ok
            {
                json?(j)
            }
            else
            {
                fail?(status)
            }
        }, fail: fail)
    }
    
    static func multipartUploadRequest(url: String, path: String, body: [String : Any] = [:], files: [MultipartFile], successResponse: SuccessBlock, fail: FailBlock)
    {
        self.multipartUploadRequest(url: url, path: path, body: body, files: files, success: { response, status in
            
            successResponse?(response, status)
            
        }, fail: fail)
    }
    
    static func multipartUploadRequest(url: String, path: String, body: Body? = .default, files: [MultipartFile], success: SuccessBlock, fail: FailBlock)
    {
        var headers: [String: String] = [:]
        
        headers[Network.Key.Parsing.xLanguage] = kLanguage.current.rawValue
        if let token = User.current?.accessToken, !token.isEmpty
        {
            headers[Network.Key.Parsing.authorization] = Network.Key.Parsing.bearer + token
        }
        let body = body != nil ? self.body(with: body!) : .empty
        
        self.shared.alamofire.upload(multipartFormData: { MultipartFormData in
            for item in body
            {
                if let data = "\(item.value)".data(using: .utf8)
                {
                    MultipartFormData.append(data, withName: item.key)
                }
            }
            for file in files
            {
                MultipartFormData.append(file.data, withName: file.key, fileName: file.name, mimeType: file.type)
            }
        }, to: url + path, headers: headers, encodingCompletion: { result in
            debugPrint(result)
            
            switch(result)
            {
            case .success(let request, _, _):
                
                debugPrint(request)
                
                print("Url: " + (request.request?.url?.absoluteString ?? "-1"))
                print(headers)
                print(body)
                
                request.responseJSON { response in
                    
                    print("Url: " + (response.response?.url?.absoluteString ?? "-1"))
                    print("Status code: " + (response.response?.statusCode.toString ?? "-1"))
                    
                    switch(response.result)
                    {
                    case .success(let value):
                        print(value)
                        success?(value, .success)
                    case .failure(let error):
                        print(error)
                        print(String(data: response.data ?? Data(), encoding: .utf8) ?? "")
                        fail?(Status(error: error))
                    }
                }
            case .failure(let error):
                fail?(Status(error: error))
            }
        })
    }
    
}

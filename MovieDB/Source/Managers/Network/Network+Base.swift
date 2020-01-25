//
//  Network+Base.swift
//
//  Created by Giorgi Iashvili on 25.01.17.
//  Copyright © 2017 Giorgi Iashvili. All rights reserved.
//

import RDExtensionsSwift
import Alamofire
import SwiftyJSON

public class Network {
    
    struct UnauthorizedRequest {
        
        var request: NSMutableURLRequest
        var success: Any?
       // var fail: FailBlock
        
    }
    
    struct NoInternetRequest {
        
        var request: NSMutableURLRequest
        var success: Any?
        var fail: FailBlock
        
    }
    
    typealias AnyResponseBlock = ((_ response: DataResponse<Any>) -> Void)?
    typealias StringResponseBlock = ((_ response: DataResponse<String>) -> Void)?
    typealias DataResponseBlock = ((_ response: DataResponse<Data>) -> Void)?
    typealias EmptyBlock = (() -> Void)?
    typealias ProgressBlock = ((_ completed: Double) -> Void)?
    typealias FileBlock = ((_ fileUrl: URL) -> Void)?
    typealias AnyBlock = ((_ response: Any) -> Void)?
    typealias DataBlock = ((_ response: Data) -> Void)?
    typealias JsonBlock = ((_ response: JSON) -> Void)?
    typealias StringBlock = ((_ response: String) -> Void)?
    typealias DecodableBlock = ((_ response: Decodable) -> Void)?
    typealias FailBlock = ((_ status: Status) -> Void)?
    
    typealias MultipartFile = (key: String, name: String, data: Data, type: String)
    typealias SuccessBlock = ((_ response: Any, _ status: Status) -> Void)?
    
    static let shared = Network()
    
    let alamofire: Alamofire.SessionManager = {
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: [
                :
//                Constants.Network.APIDomain                 :       .disableEvaluation
            ])
        )
        
        return manager
    }()
    
    var unauthorizedRequests: [UnauthorizedRequest] = []
    var noInternetRequests: [NoInternetRequest] = []
    
    init()
    {
        self.alamofire.delegate.sessionDidReceiveChallenge = { [weak self] session, challenge in
            var disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
            var credential: URLCredential?
            switch(challenge.protectionSpace.authenticationMethod)
            {
            case NSURLAuthenticationMethodServerTrust:
                disposition = URLSession.AuthChallengeDisposition.useCredential
                if let secTrust = challenge.protectionSpace.serverTrust
                {
                    credential = URLCredential(trust: secTrust)
                }
            default:
                if(challenge.previousFailureCount > 0)
                {
                    disposition = .cancelAuthenticationChallenge
                }
                else
                {
                    credential = self?.alamofire.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if(credential != nil)
                    {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
    }
    
}

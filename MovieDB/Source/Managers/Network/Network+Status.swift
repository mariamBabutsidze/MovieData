//
//  Network+Status.swift
//
//  Created by Giorgi Iashvili on 4/5/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Network {
    
    class Status: Error, Decodable {
        
        enum kCode: Int {
            
            // MARK: - General Codes
            case unknown = 0
            case OK = 1
            case GeneralError = -1
            case NotFound = -2
            case TermsNotAcepted = -3
            case UserHasNoCards = -4
            case noInternetConnection = -101
            
            // MARK: - HTTP Status Codes
            case `continue` = 100
            case switchingProtocols = 101
            case processing = 102
            case earlyHints = 103
            
            case ok = 200
            case created = 201
            case accepted = 202
            case nonAuthoritativeInformation = 203
            case noContent = 204
            case resetContent = 205
            case partialContent = 206
            case multiStatus = 207
            case alreadyReported = 208
            case iAmUsed = 226
            
            case multipleChoices = 300
            case movedPermanently = 301
            case found = 302
            case seeOther = 303
            case notModified = 304
            case useProxy = 305
            case switchProxy = 306
            case temporaryRedirect = 307
            case permanentRedirect = 308
            
            case badRequest = 400
            case unauthorized = 401
            case paymentRequired = 402
            case forbidden = 403
            case notFound = 404
            case methodNotAllowed = 405
            case notAcceptable = 406
            case proxyAuthenticationRequired = 407
            case requestTimeout = 408
            case conflict = 409
            case gone = 410
            case lengthRequired = 411
            case preconditionFailed = 412
            case payloadTooLarge = 413
            case uRITooLong = 414
            case unsupportedMediaType = 415
            case rangeNotSatisfiable = 416
            case expectationFailed = 417
            case iAmATeapot = 418
            case misdirectedRequest = 421
            case unprocessableEntity = 422
            case locked = 423
            case failedDependency = 424
            case upgradeRequired = 426
            case preconditionRequired = 428
            case tooManyRequests = 429
            case requestHeaderFieldsTooLarge = 431
            case unavailableForLegalReasons = 451
            
            case internalServerError = 500
            case notImplemented = 501
            case badGateway = 502
            case serviceUnavailable = 503
            case gatewayTimeout = 504
            case httpVersionNotSupported = 505
            case variantAlsoNegotiates = 506
            case insufficientStorage = 507
            case loopDetected = 508
            case notExtended = 510
            case networkAuthenticationRequired = 511
            
            // MARK: - Custom Code
            case easyLoginDisabled = 600
            case relogin = 601
            
            case invalidUserNameOrPassword = 1005
            case unavailableMail = 1012
            
            static var successCodes: [kCode] { get { return [ok, .OK, .created, .accepted, .nonAuthoritativeInformation, .noContent, .resetContent, .partialContent, .multiStatus, .alreadyReported, .iAmUsed] } }
        }
        
        static var error: Status { get { return Status(code: .unknown) } }
        static var success: Status { get { return Status(code: .ok) } }
        
        var code = kCode.unknown
        private var _message: String?
        private var localMessageKey: String { get { return "ErrorCode_" + self.code.toString } }
        private var localMessage: String { get { return LocalString(self.localMessageKey) == self.localMessageKey ? LocalString("ErrorCode_" + kCode.unknown.toString) : LocalString(self.localMessageKey) } }
        var localizedDescription: String { get { return self._message?.isEmpty == false ? self._message! : self.localMessage } set { self._message = newValue } }
        private(set) var json: JSON?
        
        static func decode(from data: Data?) -> Self
        {
            if let status = self.decode(from: data)
            {
                return status
            }
            else
            {
                return self.init(code: .unknown)
            }
        }
        
        required init(from decoder: Decoder) throws
        {
            let json = try JSON(from: decoder)
            var codeValue = json[Key.Coding.success.rawValue].intValue
            codeValue = codeValue == 1 ? kCode.ok.rawValue : codeValue
            self.code = kCode(rawValue: codeValue) ?? .unknown
            let errors = json[Key.Coding.errors.rawValue].rawValue as? [String] ?? []
            if !errors.isEmpty{
                self._message = errors.first
            }
            self.json = json[Key.Coding.data.rawValue]
        }
        
        required init(code: kCode, message: String? = nil, jsonData: Any? = nil)
        {
            self.code = code
            self._message ?= message
            if let jsonData = jsonData
            {
                self.json = JSON(jsonData)
            }
        }
        
        init(code: Int, message: String? = nil, jsonData: Any? = nil)
        {
            self.code = kCode(rawValue: code) ?? .unknown
            self._message ?= message
            if let jsonData = jsonData
            {
                self.json = JSON(jsonData)
            }
        }
        
        init(error: Error, code: Int? = nil, message: String? = nil, jsonData: Any? = nil)
        {
            if let errorCode = kCode(rawValue: (error as NSError).code)
            {
                self.code = errorCode
            }
            if let code = code,
                let errorCode = kCode(rawValue: code)
            {
                self.code = errorCode
            }
            if(!Network.isConnectedToNetwork)
            {
                self.code = .noInternetConnection
            }
            self._message ?= message
            if let jsonData = jsonData
            {
                self.json = JSON(jsonData)
            }
        }
        
        private static func _error<T>(with message: String?) -> T?
        {
            let status = self.error
            status._message = message
            return status as? T
        }
        
        static func error(with message: String?) -> Self
        {
            return self._error(with: message)!
        }
        
    }
    
}

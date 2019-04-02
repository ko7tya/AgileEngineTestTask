//
//  APIError.swift
//  Shupperz
//
//  Created by Kostya on 03.07.2018.
//

import Foundation

public enum APIError: LocalizedError {
    case notConnectedToInternet(info: String)
    case notReachedServer(info: String)
    case connectionLost(info: String)
    case incorrectDataReturned(info: String)
    case invalidAPICall(info: String)
    case invalidAuthorizationToken(info: String)
    case invalidServerResponse(info: String)
    case mappingFailed(info: String)
    case statusError(info: String)
    case systemError(info: String)
    case nsError(NSError)
    case unknown(info: String)
    case couldNotParseJSON(info: String)
    case empty
    case disconnected(info: String)
    case tokenError(info: String)
    case socketError(info: String)
    
    public var errorDescription: String? {
        return errorMessage()
    }
    
    fileprivate func errorMessage() -> String {
        var messageString: String = ""
        
        let mirror = Mirror(reflecting: self)
        if mirror.displayStyle == .enum, let associated = mirror.children.first {
            messageString.append("\(associated.value)")
        } else {
            messageString.append("Uknown")
        }
        return messageString
    }
    
    internal var toNSError: NSError {
        let userInfo: [String: Any] = [NSLocalizedDescriptionKey: errorMessage()]
        return NSError(domain: "APICallErrorDomain", code: 1, userInfo: userInfo)
    }
    
}

//
//  API.swift
//  Ward
//
//  Created by Kostya on 2/8/19.
//  Copyright © 2019 Kostya. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

enum API {
    case getGallery(page: Int)
    case getPhoto(_ id: String)
    case authorize(token: String)
}

extension API: TargetType, APIType {
    
    var isAutorized: Bool {
        switch self {
        case .getPhoto, .getGallery:
            return true
        case .authorize:
            return false
        }
    }
    
    var baseURL: URL {
        return Configuration.baseURL
    }
    
    var path: String {
        switch self {
        case .authorize:
            return "auth"
        case .getGallery:
            return "images"
        case .getPhoto(let id):
            return "images/\(id)"
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .authorize:
            return .post
        case .getGallery, .getPhoto:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        
        switch self {
        case .authorize:
            return nil
        case .getPhoto, .getGallery:
            guard let token = TokenResponse.getToken() else {
                return nil
            }
            return ["Authorization": "Bearer \(token)"]
        }
    }
    
    var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post, .put:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .authorize(let token):
            return ["apiKey": token]
        case .getGallery(let page):
            return ["page": page]
        case .getPhoto:
            return nil
        }
    }
}

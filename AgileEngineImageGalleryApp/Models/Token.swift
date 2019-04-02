//
//  Token.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import Foundation

struct TokenResponse: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
    }
    
    func save() {
        UserDefaults.standard.set(self.token, forKey: Configuration.tokenKey)
    }
    
    static func getToken() -> String? {
        return UserDefaults.standard.object(forKey: Configuration.tokenKey) as? String
    }
}

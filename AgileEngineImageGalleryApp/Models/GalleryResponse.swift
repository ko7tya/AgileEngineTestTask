//
//  GalleryResponse.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import Foundation

struct GalleryResponse: Codable {
    
    let pictures: [GalleryPhoto]
    
    enum CodingKeys: String, CodingKey {
        case pictures
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pictures, forKey: .pictures)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pictures = try container.decode([GalleryPhoto].self, forKey: .pictures)
    }
    
}

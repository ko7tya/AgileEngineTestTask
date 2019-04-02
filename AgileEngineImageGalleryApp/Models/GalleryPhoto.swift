//
//  GalleryPhoto.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import Foundation


struct GalleryPhoto: Codable {
    let id: String
    let croppedPicture: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case croppedPicture = "cropped_picture"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(croppedPicture, forKey: .croppedPicture)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        croppedPicture = try container.decode(String.self, forKey: .croppedPicture)
    }
    
}

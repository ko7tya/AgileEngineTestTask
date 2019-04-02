//
//  Photo.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import Foundation

struct FullPhoto: Codable {
    
    let id: String
    let author: String
    let camera: String
    let croppedPicture: String
    let fullPicture: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case camera
        case croppedPicture = "cropped_picture"
        case fullPicture = "full_picture"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(author, forKey: .author)
        try container.encode(camera, forKey: .camera)
        try container.encode(croppedPicture, forKey: .croppedPicture)
        try container.encode(fullPicture, forKey: .fullPicture)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        author = try container.decode(String.self, forKey: .author)
        camera = try container.decode(String.self, forKey: .camera)
        croppedPicture = try container.decode(String.self, forKey: .croppedPicture)
        fullPicture = try container.decode(String.self, forKey: .fullPicture)
    }
    
}

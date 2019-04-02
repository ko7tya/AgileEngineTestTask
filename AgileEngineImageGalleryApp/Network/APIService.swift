//
//  APIService.swift
//  Ward
//
//  Created by Kostya on 2/8/19.
//  Copyright © 2019 Kostya. All rights reserved.
//

import Foundation
import RxSwift
import Result

typealias TokenResult = Observable<Result<TokenResponse, APIError>>
typealias GalleryResult = Observable<Result<GalleryResponse, APIError>>
typealias FullPhotoResult = Observable<Result<FullPhoto,APIError>>

protocol APIServiceType {
    func auth(apiKey: String) -> TokenResult
    func getGallery(page: Int) -> GalleryResult
    func getPhoto(id: String) -> FullPhotoResult
}

class APIService: APIServiceType {
    
    class func shared() -> APIServiceType {
        return sharedService
    }
    
    private static var sharedService: APIServiceType = {
        let service = APIService(with: Networking.newNetworking())
        return service
    }()
    
    let service: Networking
    
    private init(with service: Networking) {
        self.service = service
    }
    
    func getPhoto(id: String) -> FullPhotoResult {
        let endpoint = API.getPhoto(id)
        return service.provider
            .request(endpoint)
            .mapTo(object: FullPhoto.self)
    }
    
    func auth(apiKey: String) -> TokenResult {
        let endpoint = API.authorize(token: apiKey)
        return service.provider
            .request(endpoint)
            .mapTo(object: TokenResponse.self)
    }
    
    func getGallery(page: Int) -> GalleryResult {
        let endpoint = API.getGallery(page: page)
        return service.provider
            .request(endpoint)
            .mapTo(object: GalleryResponse.self)
    }
   
}

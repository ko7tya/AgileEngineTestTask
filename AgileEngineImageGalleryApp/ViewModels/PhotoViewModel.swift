//
//  PhotoViewModel.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhotoViewModel{
    var apiService: APIServiceType
    let bag = DisposeBag()
    init(with apiService: APIServiceType = APIService.shared()) {
        self.apiService = apiService
    }
    
    var photo: PublishRelay<FullPhoto?> = PublishRelay<FullPhoto?>()
    
    func getPhoto(with id: String) {
        
        apiService.getPhoto(id: id).subscribe(onNext: { (response) in
            
            switch response {
            case .success(let photo):
                self.photo.accept(photo)
            case .failure(let error):
                //handle error
                break
            }
            
        }).disposed(by: bag)
        
    }
    
}

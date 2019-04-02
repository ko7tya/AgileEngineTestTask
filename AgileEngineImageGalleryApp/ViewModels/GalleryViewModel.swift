//
//  GalleryViewModel.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Result

class GalleryViewModel {
    
    var apiService: APIServiceType
    var croppedPhotos: Variable<[GalleryPhoto]> = Variable([])
    let bag = DisposeBag()
    var page = 0
    init(with apiService: APIServiceType = APIService.shared()) {
        self.apiService = apiService
    }
    
    func getData(page: Int) {
        apiService.getGallery(page: page).subscribe(onNext: { response in
            switch response {
            case .success(let data):
                self.croppedPhotos.value.append(contentsOf: data.pictures)
            case .failure(let error):
                debugPrint(error)
                break
            }

        }).disposed(by: bag)
        
    }
    
    func loadNextPage() {
        page += 1
        getData(page: page)
    }
    
    func startFlow() {
        getData(page: page)
    }
    
    func autorize() {
        apiService.auth(apiKey: Configuration.apiKey)
            .subscribe(onNext: { response in
                switch response {
                case .success(let tokenResponse):
                    tokenResponse.save()
                    self.startFlow()
                case .failure:
                    //Handle error
                    break
                }
            })
            .disposed(by: bag)
    }
}

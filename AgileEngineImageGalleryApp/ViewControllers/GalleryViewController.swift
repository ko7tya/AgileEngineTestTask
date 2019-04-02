//
//  GalleryViewController.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class GalleryViewController: UIViewController {
    
    typealias Cell = GalleryCollectionViewCell
    
    let flowlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = GalleryViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.autorize()
        prepareUI()
    }
    
    func prepareUI() {
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))

        viewModel.croppedPhotos.asObservable().bind(to: collectionView.rx.items(cellIdentifier: Cell.cellIdentifier, cellType: Cell.self)){ (row, element, cell) in
                cell.set(element)
            }
            .disposed(by: bag)
        
        collectionView.rx.setDelegate(self).disposed(by: bag)
        collectionView.rx.contentOffset.asDriver()
            .map { _ in self.shouldRequestNextPage() }
            .distinctUntilChanged()
            .drive(onNext: { _ in self.viewModel.loadNextPage() })
            .disposed(by: bag)
        
        collectionView
            .rx
            .modelSelected(GalleryPhoto.self)
            .subscribe(onNext: { (photo) in
                self.open(photo)
            }).disposed(by: bag)
        
        
        
    }
    
    private func open(_ photo: GalleryPhoto) {
         let vc: PhotoViewController = PhotoViewController.instantiate(storyboard: .main)
        
        vc.photoID = photo.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func shouldRequestNextPage() -> Bool {
        return collectionView.contentSize.height > 0 &&
            collectionView.isNearBottomEdge()
    }
    
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}

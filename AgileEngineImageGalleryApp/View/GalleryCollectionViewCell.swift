//
//  GalleryCollectionViewCell.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import UIKit
import AlamofireImage

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: GalleryCollectionViewCell.self)
    
    let imageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFit
        return imv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.af_cancelImageRequest()
        imageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(imageView, constraints: equalParent())
    }
    
    public func set(_ galleryPhoto: GalleryPhoto) {
        guard let url = URL(string: galleryPhoto.croppedPicture) else {
            return
        }
        imageView.af_setImage(withURL: url)
    }
    
}

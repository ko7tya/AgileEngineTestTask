//
//  PhotoViewController.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift
import RxCocoa

class PhotoViewController: UIViewController {

    let viewModel = PhotoViewModel()
    var photoID: String!
    var photo: FullPhoto?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        viewModel.getPhoto(with: photoID)
        // Do any additional setup after loading the view.
    }
    
    func prepareUI() {
        
        hero.isEnabled = true        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        viewModel.photo.asObservable().bind { [unowned self] photo in
            if let photo = photo {
                self.setup(with: photo)
            }
        }.disposed(by: bag)
    }
    
    private func setup(with model: FullPhoto) {
        photo = model
        title = "Photo by \(model.author)"
        
        if let fullImageUrl = URL(string: model.fullPicture) {
            imageView.af_setImage(withURL: fullImageUrl)
            authorNameLabel.text = model.author
            cameraLabel.text = model.camera
        }
    }
    @IBAction func shareButtonAction(_ sender: Any) {
        guard let photo = photo else {
            return
        }
        showActitvityIndicator(for: photo)
    }
    
    private func showActitvityIndicator(for photo: FullPhoto) {
        guard let url = URL(string: photo.fullPicture) else {
            return
        }
        let dataToShare = [ url ]
        let activityViewController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
}

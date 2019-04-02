//
//  Storuboard+Extension.swift
//  AgileEngineImageGalleryApp
//
//  Created by Kostyantin Ischenko on 4/2/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import Foundation
import UIKit

enum Storyboards: String {
    case main = "Main"
}

extension UIViewController {
    
    class func instantiate<T: UIViewController>(storyboard: Storyboards) -> T {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Cannot create \(T.self)")
        }
        return vc
    }
}

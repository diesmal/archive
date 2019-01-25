//
//  HDXRouter.swift
//  HexadTestApp
//
//  Created by di on 02.01.19.
//  Copyright © 2019 Ilia Nikolaenko. All rights reserved.
//

import UIKit

class HDXListRouter : HDXRouter {
    var managedViewController: UIViewController
    
    required init(_ managedViewController: UIViewController) {
        self.managedViewController = managedViewController
    }
    
    func showRateMovieAlert(name: String, _ completion: @escaping (_ rating: Int?) -> Void) {
        HDXRateAlert.present(on: self.managedViewController, name: name, completion)
    }
    
}

//
//  HDXRateAlert.swift
//  HexadTestApp
//
//  Created by di on 02.01.19.
//  Copyright © 2019 Ilia Nikolaenko. All rights reserved.
//

import UIKit

struct HDXRateAlert {
    
    static func present(on viewController: UIViewController, name: String, _ completion: @escaping (_ rating: Int?) -> Void ) {
        let alert = UIAlertController(title: "Rate \(name)", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "⭐️", style: .default, handler: { (_) in
            completion(1)
        }))
        alert.addAction(UIAlertAction(title: "⭐️⭐️", style: .default, handler: { (_) in
            completion(2)
        }))
        alert.addAction(UIAlertAction(title: "⭐️⭐️⭐️", style: .default, handler: { (_) in
            completion(3)
        }))
        alert.addAction(UIAlertAction(title: "⭐️⭐️⭐️⭐️", style: .default, handler: { (_) in
            completion(4)
        }))
        alert.addAction(UIAlertAction(title: "⭐️⭐️⭐️⭐️⭐️", style: .default, handler: { (_) in
            completion(5)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            completion(nil)
        }))
        
        viewController.present(alert, animated: true)
    }
    
}

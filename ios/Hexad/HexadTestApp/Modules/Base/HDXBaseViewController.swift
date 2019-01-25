//
//  HDXBaseViewController.swift
//  HexadTestApp
//
//  Created by di on 31.12.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import UIKit
import RxSwift

class HDXBaseViewController: UIViewController {
    
    let disposableBag = DisposeBag()
    
    var assembly: HDXAssembly? { return nil }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let assembly = self.assembly {
            assembly.activate(definition: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    func bindUI() {
        // Here children must set up observers
    }
}

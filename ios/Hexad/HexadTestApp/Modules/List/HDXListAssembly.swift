//
//  HDXListAssembly.swift
//  HexadTestApp
//
//  Created by di on 31.12.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import UIKit

class HDXListAssembly: HDXAssembly {
    func activate(definition: HDXBaseViewController) {
        
        if let listViewController = definition as? HDXListViewController {
            let router = HDXListRouter(listViewController)
            listViewController.viewModel = HDXMoviesListViewModel(router: router)
        }
    }
}


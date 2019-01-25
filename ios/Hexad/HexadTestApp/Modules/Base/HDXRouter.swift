//
//  HDXRouter.swift
//  ThisOrThat
//
//  Created by di on 03.11.18.
//  Copyright © 2018 Ilya Nikolaenko. All rights reserved.
//

import UIKit

protocol HDXRouter {
    var managedViewController: UIViewController { get }
    init(_ managedViewController: UIViewController);
}

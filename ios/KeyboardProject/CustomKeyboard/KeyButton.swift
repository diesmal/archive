//
//  KeyButton.swift
//  CustomKeyboard
//
//  Created by Ilia Nikolaenko on 26.04.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import UIKit


class KeyButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            layer.transform = isHighlighted ? CATransform3DMakeScale(1.1, 1.1, 1.1) : CATransform3DMakeScale(1, 1, 1)
        }
    }
    
}

//
//  ViewController.swift
//  KeyboardProject
//
//  Created by Ilia Nikolaenko on 25.04.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }


}


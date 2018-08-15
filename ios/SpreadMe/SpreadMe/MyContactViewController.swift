//
//  MyContactViewController.swift
//  SpreadMe
//
//  Created by Ilia Nikolaenko on 11/8/17.
//  Copyright © 2017 Ilia Nikolaenko. All rights reserved.
//

import UIKit
import ContactsUI

fileprivate let MyContactKey = "my_contact"

class MyContactViewController: UIViewController, CNContactPickerDelegate {

    @IBOutlet weak var chooseContactButton: UIButton!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        if let contact = UserDefaults.standard.object(forKey: MyContactKey) as? String {
            setUp(withContactString: contact)
        }
    }
    
    func setUpView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.chooseContactButton.layer.borderWidth = 1;
        self.chooseContactButton.layer.cornerRadius = 3;
        self.chooseContactButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func onSelectContact(_ sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    @IBAction func onTrash(_ sender: UIBarButtonItem) {
        setUp(withContact: nil)
    }
    
    @IBAction func onAction(_ sender: UIBarButtonItem) {
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let textToShare = "Scan my contact with \(appName)"
        
        UIGraphicsBeginImageContext(self.qrCodeImageView.frame.size)
        self.qrCodeImageView.layer.render(in:UIGraphicsGetCurrentContext()!)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        if let image = output {
            let objectsToShare = [textToShare, image] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.toolBar
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Private
    
    func setUp(withContactString contactString: String) {
        let contact = SMCONSerialization.contactObject(with: contactString)
        setUp(withContact: contact)
    }
    
    func setUp(withContact contact: SMContact?) {
        if let contact = contact {
            let contactString = SMCONSerialization.string(withContactObject: contact)
            let qrCode = SMQRCode(message: contactString)
            
            if let image = qrCode.image() {
                self.qrCodeImageView.image = image
                self.title = contact.name + " " + contact.familyName
                
                UserDefaults.standard.set(contactString, forKey: MyContactKey)
            } else {
                print("🤬 QRCode image is nil")
            }
        } else {
            self.title = "My contact"
            self.qrCodeImageView.image = nil
            UserDefaults.standard.removeObject(forKey: MyContactKey)
        }
        
        let isContactVisible = (self.qrCodeImageView.image != nil) && (contact != nil)
        self.chooseContactButton.isHidden = isContactVisible
        self.toolBar.isHidden = !isContactVisible
        self.qrCodeImageView.isHidden = !isContactVisible
    }
    

    //MARK: CNContactPickerDelegate
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let smContact = SMContact(contact: contact)
        setUp(withContact: smContact)
    }
}

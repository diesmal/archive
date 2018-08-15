//
//  QRCodeReaderViewController.swift
//  SpreadMe
//
//  Created by Ilia Nikolaenko on 10/29/17.
//  Copyright © 2017 Ilia Nikolaenko. All rights reserved.
//

import UIKit
import AVFoundation
import ContactsUI

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CNContactViewControllerDelegate {

    @IBOutlet weak var preview: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    let store = CNContactStore()
    
    let queue = DispatchQueue(label: "queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.captureSession?.startRunning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession?.stopRunning()
    }
    
    func setUp() {
        self.captureSession = AVCaptureSession()
        //Input
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        
        guard let input = try? AVCaptureDeviceInput.init(device: captureDevice)  else {
            askUserForCameraPermission()
            return
        }
        
        self.captureSession?.addInput(input)
        
        //Output
        let captureMetadataOutput = AVCaptureMetadataOutput()
        self.captureSession?.addOutput(captureMetadataOutput)
        
        //Thread
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: queue)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        //Video layer
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreviewLayer?.frame = preview.layer.bounds
        preview.layer.addSublayer(self.videoPreviewLayer!)
        
    }

    func askUserForCameraPermission() {
        
        var message: String?
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let infoPlist = NSDictionary(contentsOfFile: path) as? [String: Any] {
                message = infoPlist["NSCameraUsageDescription"] as? String
            }
        }
        
        let alertVC = UIAlertController(title: "Camera disabled", message: message, preferredStyle: .alert)
        
        let close = UIAlertAction(title: "Close", style: .destructive, handler: nil)
        
        let openSettings = UIAlertAction(title: "Open settings", style: .default, handler: { (action) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        })
        
        alertVC.addAction(close)
        alertVC.addAction(openSettings)
        present(alertVC, animated: true, completion: nil)
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let avObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if let stringValue = avObject.stringValue {
                let smContact = SMCONSerialization.contactObject(with: stringValue)
                if let cnContact = smContact?.cnContact() {
                    self.captureSession?.stopRunning()
                    DispatchQueue.main.async {
                        let addContactController = CNContactViewController(forNewContact: cnContact)
                        addContactController.contactStore = self.store
                        addContactController.delegate = self
                        self.navigationController?.pushViewController(addContactController, animated: true)
                    }
                }
            }
        }
    }
}

//
//  SMQRCode.swift
//  SpreadMe
//
//  Created by Ilia Nikolaenko on 11/9/17.
//  Copyright © 2017 Ilia Nikolaenko. All rights reserved.
//

import UIKit

enum SMQRCodeGenerationError: Error {
    case qrCodeGeneratorNotInitialized
    case qrCodeGeneratorNotGenerate
}

struct SMQRCode {
    let message: String
    let size: CGFloat
    let correctionLevel: SMQRCodeCorrectionLevel
    
    init(message: String, size: CGFloat = 512, correctionLevel: SMQRCodeCorrectionLevel = .middle) {
        self.message = message
        self.size = size
        self.correctionLevel = correctionLevel
    }
    
    func image() -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            print("🤬 CIQRCodeGenerator is nil")
            return nil
        }
        let inputMessage = message.data(using: String.Encoding.utf8)
        
        filter.setValue(inputMessage, forKey: "inputMessage")
        filter.setValue(correctionLevel.rawValue, forKey: "inputCorrectionLevel")
        
        guard let qrcodeCoreImage = filter.outputImage else {
            print("🤬 CIQRCodeGenerator is nil")
            return nil
        }
        
        let qrcodeImage = UIImage(ciImage: qrcodeCoreImage)
        
        let scale = CGFloat(size / qrcodeImage.size.width)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        
        let resizedQrCode = qrcodeCoreImage.transformed(by: transform)
        let resizedQrcodeImage = UIImage(ciImage: resizedQrCode)
        
        return resizedQrcodeImage
    }
    
}

enum SMQRCodeCorrectionLevel: String {
    case low = "L" //7%
    case middle = "M" //15%
    case quarter = "Q" //25%
    case high = "H" //30%
    
}

//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Ilia Nikolaenko on 25.04.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    var keyboardView: UIView!

    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface()
    }

    
    func loadInterface() {
        let nextKeyboardButton = KeyButton(type: .custom)
        nextKeyboardButton.frame = CGRect(x: 285, y: 5, width: 75, height: 50)
        nextKeyboardButton.setTitle("next", for: .normal)
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        nextKeyboardButton.backgroundColor = UIColor.gray
        self.view.addSubview(nextKeyboardButton)
        
        let btnA = KeyButton(type: .custom)
        btnA.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        btnA.setTitle("A", for: .normal)
        btnA.addTarget(self, action:#selector(self.onButton(button:)) , for: .touchUpInside)
        btnA.backgroundColor = UIColor.darkGray
        btnA.tag = 1
        self.view.addSubview(btnA)
        
        let btnB = KeyButton(type: .custom)
        btnB.frame = CGRect(x: 60, y: 5, width: 50, height: 50)
        btnB.setTitle("B", for: .normal)
        btnB.addTarget(self, action:#selector(self.onButton(button:)) , for: .touchUpInside)
        btnB.backgroundColor = UIColor.darkGray
        
        btnB.tag = 2
        self.view.addSubview(btnB)
        
        let btnC = KeyButton(type: .custom)
        btnC.frame = CGRect(x: 115, y: 5, width: 50, height: 50)
        btnC.setTitle("C", for: .normal)
        btnC.addTarget(self, action:#selector(self.onButton(button:)) , for: .touchUpInside)
        btnC.backgroundColor = UIColor.darkGray
        btnC.tag = 3
        self.view.addSubview(btnC)
        
        let replace = KeyButton(type: .custom)
        replace.frame = CGRect(x: 175, y: 5, width: 100, height: 50)
        replace.setTitle("replace", for: .normal)
        replace.setTitleColor(UIColor.white, for: .normal)
        replace.addTarget(self, action:#selector(self.onReplace) , for: .touchUpInside)
        replace.backgroundColor = UIColor.gray
        self.view.addSubview(replace)
        
//        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        someView.backgroundColor = UIColor.red
//        self.view.addSubview(someView)
    }
    
    @objc func onReplace() {
        guard var selectedText = self.textDocumentProxy.selectedText else {
            return;
        }

        
//        selectedText = selectedText.replacingOccurrences(of: "☀", with: "A")
//        selectedText = selectedText.replacingOccurrences(of: "☽", with: "B")
//        selectedText = selectedText.replacingOccurrences(of: "☁", with: "C")
        
        selectedText = selectedText.replacingOccurrences(of: "A", with: "☀")
        selectedText = selectedText.replacingOccurrences(of: "B", with: "☽")
        selectedText = selectedText.replacingOccurrences(of: "C", with: "☁")
        
        self.textDocumentProxy.insertText(selectedText)
    }
    
    
    @objc func onButton(button: UIButton){
        switch button.tag {
        case 1:
            self.textDocumentProxy.insertText("A")
        case 2:
            self.textDocumentProxy.insertText("B")
        case 3:
            self.textDocumentProxy.insertText("C")
        default:
            self.textDocumentProxy.insertText(" ")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.textDocumentProxy.deleteBackward()
            switch button.tag {
            case 1:
                self.textDocumentProxy.insertText("☀")
            case 2:
                self.textDocumentProxy.insertText("☽")
            case 3:
                self.textDocumentProxy.insertText("☁")
            default:
                self.textDocumentProxy.insertText(" ")
            }
        }
        
        if let buffer = UIPasteboard.general.string {
            self.textDocumentProxy.insertText(buffer)
        }
    }
    
    @objc func printText(){
        let value = (textDocumentProxy.documentContextBeforeInput ?? "") + (textDocumentProxy.documentContextAfterInput ?? "")
        print(value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
       // self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}

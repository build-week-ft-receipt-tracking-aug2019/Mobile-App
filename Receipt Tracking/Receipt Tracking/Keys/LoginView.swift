//
//  LoginView.swift
//  Receipt Tracking
//
//  Created by Alex Rhodes on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import UIKit

class LoginView {
    
    func currentViewConfiguration(view: UIView) {
        
        view.backgroundColor = .black
        
    }
    
    func textFieldConfiguration(textField: UITextField) {
        
        // Set background color
        textField.backgroundColor = .receiptGray
        
        // Fix border width, color, and corner radius
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        // Clears text on new insertion
        textField.clearsOnInsertion = true
        
        // Set left margin so text starts after icon
        let spacerView = UIView(frame:CGRect(x:0, y:0, width: 50, height:10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        
    }
    
    func buttonConfiguration(button: UIButton) {
        button.backgroundColor = .receiptMidGreen
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(.receiptWhite, for: .normal)
        button.layer.cornerRadius = 5
    }
}

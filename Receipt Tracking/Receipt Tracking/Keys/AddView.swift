//
//  AddView.swift
//  Receipt Tracking
//
//  Created by Alex Rhodes on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import UIKit

class AddView {
    
    func viewConfiguration(view: UIView) {
        view.backgroundColor = .receiptGray
    }
    
    func navBarConfiguration(navBar: UINavigationBar) {
        // Setting navigation bar to a custom color
        navBar.isTranslucent = false
        navBar.backgroundColor = .receiptDarkGreen
        navBar.barTintColor = .white
        
    }
    
    func photoUploadButtonConfiguration(button: UIButton) {
        // Set background color
        button.backgroundColor = .receiptGray
        
        // Set title name
        button.setTitle("UPLOAD RECEIPT IMAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
    }
    
    func textFieldConfiguration(textField: UITextField) {
        // Set background color
        textField.backgroundColor = .receiptGray
        
        // Fix border width, color, and corner radius
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func imageViewConfiguration(imageView: UIImageView) {
        imageView.backgroundColor = .receiptWhite
    }
    
    func datePickerConfiguration(picker: UIDatePicker) {
        picker.setValue(UIColor.receiptDarkGreen, forKey: "textColor")
    }
    
    func barButtonItemConfiguration(barButton: UIBarButtonItem) {
        barButton.setValue(UIColor.receiptWhite, forKey: "textColor")
    }
    
}

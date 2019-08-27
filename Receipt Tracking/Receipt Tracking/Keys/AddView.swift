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
        // Set background color
        view.backgroundColor = .black
    }
    
    func navBarConfiguration(navBar: UINavigationBar) {
        // Setting navigation bar to a custom color
        navBar.barTintColor = .receiptMidGreen
        navBar.backgroundColor = .receiptMidGreen
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.receiptWhite]
    }
    
    func photoUploadButtonConfiguration(button: UIButton) {
        // Set background color
        button.backgroundColor = .darkGray
        
        // Set title name
        button.setTitle("UPLOAD RECEIPT IMAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        // Set corner radius
        button.layer.cornerRadius = 5
    }
    
    func textFieldConfiguration(textField: UITextField) {
        // Set background color
        textField.backgroundColor = .receiptGray
        
        // Fix border width, color, and corner radius
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.backgroundColor = .receiptWhite
    }
    
    func imageViewConfiguration(imageView: UIImageView) {
        // Set background color
        imageView.backgroundColor = .receiptGray
    }
    
    func datePickerConfiguration(picker: UIDatePicker) {
        // Set text color
        picker.setValue(UIColor.receiptWhite, forKey: "textColor")
    }
    
    func barButtonItemConfiguration(barButton: UIBarButtonItem) {
        // Set text color
    
    }
    
    func toolbarConfiguration(toolbar: UIToolbar) {
        toolbar.barTintColor = .black
    }
    
}

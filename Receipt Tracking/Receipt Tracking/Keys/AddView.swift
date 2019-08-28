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
        
        // Setting navigation bar to black
        navBar.barStyle = .black
        
    }
    
    func editUploadedPhoto(button: UIButton) {
        
        // Set background color
        button.backgroundColor = .receiptMidGreen
        
        // Set title name
        button.setTitle("EDIT RECEIPT IMAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        // Set corner radius
        button.layer.cornerRadius = 5
        
    }
    
    func photoUploadButtonConfiguration(button: UIButton) {
        
        // Set background color
        button.backgroundColor = .receiptMidGreen
        
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
        imageView.backgroundColor = .darkGray
        
    }
    
    
    func barButtonItemConfiguration(barButton: UIBarButtonItem) {
        
        // Set text color
        barButton.tintColor = .receiptWhite
        
    
    }
    
    func toolbarConfiguration(toolbar: UIToolbar) {
        
        toolbar.barTintColor = .black
        
    }
}

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
    
    func configureAmountTextView(textField: UITextField) {
        // Set background color
        textField.backgroundColor = .receiptGray
        
        // Fix border width, color, and corner radius
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.backgroundColor = .receiptGray
        
        let spacerView = UIView(frame:CGRect(x:0, y:0, width: 20, height:10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        
    }
    
    func textFieldConfiguration(textField: UITextField) {
        
        // Set background color
        textField.backgroundColor = .receiptGray
        
        // Fix border width, color, and corner radius
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.backgroundColor = .receiptGray
        
        let spacerView = UIView(frame:CGRect(x:0, y:0, width: 12, height:10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
    }

	func textLabelColorsWhite(textLabel: UILabel) {
		// Sets the text label color to white
		textLabel.textColor = .receiptWhite
	}

	func textLabelColorsDarkGreen(textLabel: UILabel) {
		// Sets the text label color to dark green
		textLabel.textColor = .receiptDarkGreen
	}

	func textlabelColorsLightGreen(textLabel: UILabel) {
		// Sets the text label coloe to light green
		textLabel.textColor = .receiptLightGreen
	}


    
    func imageViewConfiguration(imageView: UIImageView) {
        // Set background color
        imageView.backgroundColor = .darkGray
        
        #warning("don't forget to create an outlet and pass in the view. Keep calm and code on - xoxo Alex")
        // Set corner radius
//        imageView.layer.cornerRadius = 5
//        imageView.layer.masksToBounds = true
        
    }
    
    
    func barButtonItemConfiguration(barButton: UIBarButtonItem) {
        
        // Set text color
        barButton.tintColor = .receiptWhite
        
    
    }
    
    func toolbarConfiguration(toolbar: UIToolbar) {
        
        toolbar.barTintColor = .black
        
    }
}

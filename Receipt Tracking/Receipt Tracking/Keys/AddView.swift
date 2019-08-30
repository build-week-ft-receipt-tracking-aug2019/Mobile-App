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
		navBar.barTintColor = .black
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.receiptWhite]
		navBar.tintColor = .white

    }

	func navBarConfiguration2(navBar: UINavigationBar) {

		// Formatting the navigation bar in the ReceiptDetailVC
		//navBar.barTintColor = .black
		navBar.barStyle = .black
		navBar.tintColor = .white
		
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
        
        // Indent text
        let spacerView = UIView(frame:CGRect(x:0, y:0, width: 18, height:10))
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
        
        let spacerView = UIView(frame:CGRect(x:0, y:0, width: 8, height:10))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
    }

	func textLabelColorsWhite(textLabel: UILabel) {
		// Sets the text label color to white
		textLabel.textColor = .receiptGray
	}

	func textLabelColorsDarkGreen(textLabel: UILabel) {
		// Sets the text label color to dark green
		textLabel.textColor = .receiptDarkGreen
	}

	func textlabelColorsLightGreen(textLabel: UILabel) {
		// Sets the text label coloe to light green
		textLabel.textColor = .receiptLightGreen
	}

    func textlabelColorsMidGreen(textLabel: UILabel) {
        // Sets the text label coloe to light green
        textLabel.textColor = .receiptMidGreen
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

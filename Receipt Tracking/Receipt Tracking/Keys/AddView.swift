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
    
    func datePickerConfiguration(picker: UIDatePicker) {
        picker.datePickerMode = .date
    }
    
    func categoryPickerConfiguration(picker: UIPickerView, textField: UITextField) {
        
        picker.backgroundColor = .black
        picker.setValue(UIColor.receiptWhite, forKey: "textColor")
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = picker
        textField.inputAccessoryView = toolBar
        
//        picker.addSubview(toolBar)
        
    }
    
    func viewConfiguration(view: UIView) {
        // Set background color
        view.backgroundColor = .black
    }
    
    func navBarConfiguration(navBar: UINavigationBar) {
        // Setting navigation bar to a custom color
        
        navBar.barStyle = .black
//        navBar.barTintColor = .receiptMidGreen
//        navBar.backgroundColor = .receiptMidGreen
//
		navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.receiptWhite]

		navBar.tintColor = .white

		
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
    }
    
//    func datePickerConfiguration(picker: UIDatePicker) {
//        // Set text color
//        picker.setValue(UIColor.receiptWhite, forKey: "textColor")
//    }
    
    func barButtonItemConfiguration(barButton: UIBarButtonItem) {
        // Set text color
        barButton.tintColor = .receiptWhite
    
    }
    
    func toolbarConfiguration(toolbar: UIToolbar) {
        toolbar.barTintColor = .black
    }
    
}

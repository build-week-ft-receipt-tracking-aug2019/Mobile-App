//
//  AddReceiptViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class AddReceiptViewController: UIViewController {
    
    var addView = AddView()
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var merchantTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
    
    private func setViews() {
        
        addView.navBarConfiguration(navBar: navigationController!.navigationBar)
        addView.barButtonItemConfiguration(barButton: cancelBarButton)
        addView.barButtonItemConfiguration(barButton: saveBarButton)
        addView.imageViewConfiguration(imageView: receiptImageView)
        addView.textFieldConfiguration(textField: merchantTextField)
        addView.textFieldConfiguration(textField: categoryTextField)
        addView.textFieldConfiguration(textField: amountTextField)
        addView.datePickerConfiguration(picker: datePicker)
        addView.photoUploadButtonConfiguration(button: uploadPhotoButton)
        addView.viewConfiguration(view: view)
        addView.toolbarConfiguration(toolbar: toolbar)
        
    }
    
    @IBAction func uploadPhotoButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }
    
}

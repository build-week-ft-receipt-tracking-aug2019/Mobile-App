//
//  AddReceiptViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class AddReceiptViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var addView = AddView()
    
    var categoryPickerData: [String] = []
    
    var categoryPicker: UIPickerView! = UIPickerView()
    
    var datePicker: UIDatePicker! = UIDatePicker()
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var merchantTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
    
    private func setViews() {
        
        addView.navBarConfiguration(navBar: navigationController!.navigationBar)
        addView.barButtonItemConfiguration(barButton: cancelBarButton)
        addView.barButtonItemConfiguration(barButton: saveBarButton)
        addView.imageViewConfiguration(imageView: receiptImageView)
        addView.photoUploadButtonConfiguration(button: uploadPhotoButton)
        addView.viewConfiguration(view: view)
        addView.toolbarConfiguration(toolbar: toolbar)
        addView.textFieldConfiguration(textField: merchantTextField)
        addView.textFieldConfiguration(textField: amountTextField)
        addView.textFieldConfiguration(textField: categoryTextField)
        addView.textFieldConfiguration(textField: dateTextField)
        
        // Configuring Date Picker view
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .black
        datePicker.setValue(UIColor.receiptWhite, forKey: "textColor")
        
        // Adding Date Picker toolbar
        let datePickerToolBar = UIToolbar()
        datePickerToolBar.barStyle = UIBarStyle.default
        datePickerToolBar.isTranslucent = true
        datePickerToolBar.tintColor = .receiptLightGreen
        datePickerToolBar.barTintColor = .black
        datePickerToolBar.sizeToFit()
        
        let doneButtonDatePicker = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(datePickerViewDoneTapped))
        let spaceButtonDatePicker = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButtonDatePicker = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(datePickerViewCancelTapped))
        
        datePickerToolBar.setItems([cancelButtonDatePicker, spaceButtonDatePicker, doneButtonDatePicker], animated: false)
        datePickerToolBar.isUserInteractionEnabled = true
        
        // Additional Date Picker Setup
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = datePickerToolBar
        
        // Configuring Category Picker view
        categoryPicker.backgroundColor = .black
        
        // Setting Category delegate and datasource
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        // Adding Category Picker toolbar
        let categoryPickerToolBar = UIToolbar()
        categoryPickerToolBar.barStyle = UIBarStyle.default
        categoryPickerToolBar.isTranslucent = true
        categoryPickerToolBar.tintColor = .receiptLightGreen
        categoryPickerToolBar.barTintColor = .black
        categoryPickerToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(pickerViewDoneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(pickerViewCancelTapped))
        
        categoryPickerToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        categoryPickerToolBar.isUserInteractionEnabled = true
        
        // Additional Date Picker Setup
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = categoryPickerToolBar
        categoryPickerData = ["Bills", "Entertainment", "Electronics", "Apparel", "Home Appliances", "Personal Care", "Automobiles", "Groceries", "Restaurant", "Other"]
    }
    
    // MARK: Category Picker View Toolbar func
    
    @objc func pickerViewDoneTapped() {
        
        // Set up object to be saved
        
    }
    
    @objc func pickerViewCancelTapped() {
        
        categoryTextField.resignFirstResponder()
        
    }
    
    // MARK: Date Picker View Toolbar func
    
    @objc func datePickerViewDoneTapped() {
        
        // Set up object to be saved
        
    }
    
    @objc func datePickerViewCancelTapped() {
        
        dateTextField.resignFirstResponder()
        
    }
    
    // MARK: Category Picker Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryPickerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return categoryPickerData[row]
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = categoryPickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 17.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
    // MARK: Storyboard Actions
    
    @IBAction func toolBarCancelButtonTapped(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func uploadPhotoButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func toolBarSaveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    
}




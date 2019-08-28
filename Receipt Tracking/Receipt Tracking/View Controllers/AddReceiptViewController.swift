//
//  AddReceiptViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import CoreData

class AddReceiptViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets & Properties
    
    var addView = AddView()
    var categoryPickerData: [Category] = []
    var categoryPicker: UIPickerView! = UIPickerView()
    var datePicker: UIDatePicker! = UIDatePicker()
    var receiptController = ReceiptController.shared
    var receipt: Receipt?
    var category: Category?
    var selectedDate: Date?
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy, h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        return formatter
    }
    
    var user: UserRepresentation {
        let moc = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try moc.fetch(request)
            if let user = users.first {
                return user.userRepresentation
            }
        } catch {
            fatalError("Error performing fetch for user: \(error)")
        }
        return UserRepresentation()
    }
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var merchantTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
    
    // MARK: - Methods
    
    private func setViews() {
        addView.navBarConfiguration(navBar: navigationController!.navigationBar)
        addView.barButtonItemConfiguration(barButton: cancelBarButton)
        addView.barButtonItemConfiguration(barButton: saveBarButton)
        addView.imageViewConfiguration(imageView: receiptImageView)
        //addView.photoUploadButtonConfiguration(button: uploadPhotoButton)
        addView.viewConfiguration(view: view)
        addView.toolbarConfiguration(toolbar: toolbar)
        addView.textFieldConfiguration(textField: merchantTextField)
        addView.textFieldConfiguration(textField: amountTextField)
        addView.textFieldConfiguration(textField: categoryTextField)
        addView.textFieldConfiguration(textField: dateTextField)
        setUpDatePicker()
    }
    
    // MARK: Category Picker View Toolbar func
    
    @objc func pickerViewDoneTapped() {
        category = categoryPickerData[categoryPicker.selectedRow(inComponent: 0)]
        if let category = category {
            categoryTextField.text = category.rawValue
        }
        categoryTextField.resignFirstResponder()
    }
    
    @objc func pickerViewCancelTapped() {
    
        categoryTextField.resignFirstResponder()
    
    }
    
    // MARK: Date Picker View Toolbar func
    
    @objc func datePickerViewDoneTapped() {
        selectedDate = datePicker.date
        if let selectedDate = selectedDate {
            dateTextField.text = dateFormatter.string(from: selectedDate)
        }
        dateTextField.resignFirstResponder()
    }
    
    @objc func datePickerViewCancelTapped() {
        dateTextField.resignFirstResponder()
    }
    
    private func addReceipt() {
        guard let merchant = merchantTextField.text,
            !merchant.isEmpty,
            let amountSpentString = amountTextField.text,
            !amountSpentString.isEmpty,
            let category = categoryTextField.text,
            !category.isEmpty,
            let date = selectedDate,
            let username = user.username else { return }
        let amountSpent = (amountSpentString as NSString).doubleValue
        
        receiptController.createReceipt(merchant: merchant, category: category, amountSpent: amountSpent, date: date, username: username)
    }
    
    // MARK: Storyboard Actions
    
    @IBAction func toolBarCancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPhotoButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func toolBarSaveButtonTapped(_ sender: UIBarButtonItem) {
        addReceipt()
        self.dismiss(animated: true, completion: nil)
    }
    

    
}

extension AddReceiptViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryPickerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return categoryPickerData[row].rawValue
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = categoryPickerData[row]
        let myTitle = NSAttributedString(string: titleData.rawValue, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 17.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
    private func setUpDatePicker() {
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
        for category in Category.allCases {
            categoryPickerData.append(category)
    }
}

}



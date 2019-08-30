//
//  EditReceiptViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class EditReceiptViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	
	// MARK: - Properties
	var addView = AddView()
	var categoryPickerData: [String] = []
	var categoryPicker: UIPickerView! = UIPickerView()
	var category: Category?
	var selectedDate: Date?
	var datePicker: UIDatePicker! = UIDatePicker()
	let imageController = ImageController.shared
	let receiptController = ReceiptController.shared
	var receipt: Receipt?
	var image: UIImage?
	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd, yyyy"
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		return formatter
	}
	
	
	// MARK: - IBOutlets
	@IBOutlet weak var receiptImageView: UIImageView!
	@IBOutlet weak var editPhotoButton: UIButton!
	@IBOutlet weak var merchantTextField: UITextField!
	@IBOutlet weak var categoryTextField: UITextField!
	@IBOutlet weak var amountTextField: UITextField!
	@IBOutlet weak var dateTextField: UITextField!
	@IBOutlet weak var cancelBarButton: UIBarButtonItem!
	@IBOutlet weak var saveBarButton: UIBarButtonItem!
	@IBOutlet weak var toolbar: UIToolbar!
	
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setViews()
		updateViews()
	}
	
	
	// MARK: - Methods
	private func setViews() {
		addView.barButtonItemConfiguration(barButton: cancelBarButton)
		addView.barButtonItemConfiguration(barButton: saveBarButton)
		addView.imageViewConfiguration(imageView: receiptImageView)
		addView.editUploadedPhoto(button: editPhotoButton)
		addView.viewConfiguration(view: view)
		addView.toolbarConfiguration(toolbar: toolbar)
		addView.textFieldConfiguration(textField: merchantTextField)
		addView.textFieldConfiguration(textField: categoryTextField)
		addView.textFieldConfiguration(textField: dateTextField)
		addView.configureAmountTextView(textField: amountTextField)
		
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
		category = Category(rawValue: categoryPickerData[categoryPicker.selectedRow(inComponent: 0)])
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
	
	
	// MARK: Select from Camera Roll
	@IBAction func editPhotoButtonTapped(_ sender: UIButton) {
		
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
		let actionSheet = UIAlertController(title: "Photo Source", message: "Please select your photo source.", preferredStyle: .actionSheet)
		
		actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
			if UIImagePickerController.isSourceTypeAvailable(.camera) {
				imagePicker.sourceType = .camera
				self.present(imagePicker, animated: true, completion: nil)
			} else {
				let alert =  UIAlertController(title: "Camera Unavailable", message: "We were unable to gain access to your camera.", preferredStyle: .alert)
				self.present(alert, animated: true, completion: nil)
			}
		}))
		actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
			imagePicker.sourceType = .photoLibrary
			self.present(imagePicker, animated: true, completion: nil)
		}))
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
		
		present(actionSheet, animated: true, completion: nil)
	}
	
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
		receiptImageView.image = selectedImage
		
		picker.dismiss(animated: true, completion: nil)
		
	}
	
	
	// MARK: - Properties
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
		updateReceipt()
		navigationController?.popToRootViewController(animated: true)
	}
	
	
	@IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
		navigationController?.popToRootViewController(animated: true)
		dismiss(animated: true, completion: nil)
	}
	
	
	private func updateViews() {
		guard let receipt = receipt,
			let receiptDate = receipt.date,
			let merchant = receipt.merchant,
			let category = receipt.category else { return }
		let imageName = imageController.createImageName(from: receiptDate, merchant: merchant, amountSpent: receipt.amountSpent)
		if let image = imageController.getSavedImage(named: imageName) {
			receiptImageView.image = image
		}
		merchantTextField.text? = merchant
		categoryTextField.text? = category
		let amountFormatted = String(format: "$%.2f", receipt.amountSpent)
		amountTextField.text = amountFormatted
		dateTextField.text = dateFormatter.string(from: receiptDate)
	}
	
	private func updateReceipt() {
		guard let receipt = receipt,
			let merchant = merchantTextField.text,
			!merchant.isEmpty,
			let amountSpentString = amountTextField.text,
			!amountSpentString.isEmpty,
			let category = categoryTextField.text,
			!category.isEmpty,
			let dateString = dateTextField.text,
			let date = dateFormatter.date(from: dateString) else { return }
		let amountSpent = (amountSpentString as NSString).doubleValue
		let identifier = receipt.identifier
		receiptController.updateReceipt(receipt: receipt, merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: identifier)
		let imageName = imageController.createImageName(from: date, merchant: merchant, amountSpent: amountSpent)
		if let selecetedImage = receiptImageView.image {
			let _ = imageController.saveImage(image: selecetedImage, fileName: imageName)
		}
	}
}

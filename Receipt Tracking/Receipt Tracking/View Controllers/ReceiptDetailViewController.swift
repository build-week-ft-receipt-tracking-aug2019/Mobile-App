//
//  ReceiptDetailViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class ReceiptDetailViewController: UIViewController {

	// MARK: - Properties
    
	var viewDetails = AddView()
	var receipt: Receipt?
    let imageController = ImageController.shared
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }

	// Mark: - Outlets
    
	@IBOutlet weak var merchantLabelText: UILabel!
	@IBOutlet weak var dateLabelText: UILabel!
	@IBOutlet weak var categoryLabelText: UILabel!
	@IBOutlet weak var priceLabelText: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var editButtonLabel: UIBarButtonItem!

    // MARK: - View LifeCycle
    
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		updateViews()
		
    }

// MARK: - IBActions & Methods
    
	private func setupViews() {

		// Formats navigation bar and view background
		viewDetails.navBarConfiguration2(navBar: navigationController!.navigationBar)
		viewDetails.viewConfiguration(view: view)
		viewDetails.barButtonItemConfiguration(barButton: editButtonLabel)
		viewDetails.navBarConfiguration(navBar: navigationController!.navigationBar)

		// Formats label for merchant and price labels
		viewDetails.textLabelColorsWhite(textLabel: merchantLabelText)
		viewDetails.textLabelColorsWhite(textLabel: priceLabelText)

		// Formats the date label
		viewDetails.textlabelColorsLightGreen(textLabel: dateLabelText)
		viewDetails.textlabelColorsLightGreen(textLabel: categoryLabelText)

		viewDetails.imageViewConfiguration(imageView: imageView)
	}

	private func updateViews() {
        guard let receipt = receipt,
              let date = receipt.date,
              let merchant = receipt.merchant else { return }
        
        let amountSpent = receipt.amountSpent
		 let amountFormatted = String(format: "$ %.2f", amountSpent)
        merchantLabelText.text = merchant
		dateLabelText.text = dateFormatter.string(from: date)
		priceLabelText.text = amountFormatted
		categoryLabelText.text = receipt.category
    
        let imageName = imageController.createImageName(from: date, merchant: merchant, amountSpent: amountSpent)
        let image = imageController.getSavedImage(named: imageName)
        imageView.image = image
	}
}

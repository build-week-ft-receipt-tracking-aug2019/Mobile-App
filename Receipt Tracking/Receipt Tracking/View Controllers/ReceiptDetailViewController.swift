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

	// Mark: - Outlets
	@IBOutlet weak var merchantLabelText: UILabel!
	@IBOutlet weak var dateLabelText: UILabel!
	@IBOutlet weak var categoryLabelText: UILabel!
	@IBOutlet weak var priceLabelText: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var editButtonLabel: UIBarButtonItem!

	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		
    }

	private func setupViews() {

		// Formats navigation bar and view background
		viewDetails.navBarConfiguration(navBar: navigationController!.navigationBar)
		viewDetails.viewConfiguration(view: view)
		viewDetails.barButtonItemConfiguration(barButton: editButtonLabel)
		viewDetails.navBarConfiguration(navBar: self.title)



		// Formats label for merchant and price labels
		viewDetails.textLabelColorsWhite(textLabel: merchantLabelText)
		viewDetails.textLabelColorsWhite(textLabel: priceLabelText)

		// Formats the date label
		viewDetails.textlabelColorsLightGreen(textLabel: dateLabelText)

	}
    



}

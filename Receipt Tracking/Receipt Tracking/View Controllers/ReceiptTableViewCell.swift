//
//  ReceiptTableViewCell.swift
//  Receipt Tracking
//
//  Created by Percy Ngan on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {
	
	
	// MARK: - Outlets
	@IBOutlet weak var merchantLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var amountSpentLabel: UILabel!
	
	
	// MARK: - Properties
	var viewDetails = AddView()
	var receipt: Receipt? {
		didSet {
			updateViews()
		}
	}
	var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd, yyyy"
		formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
		return formatter
	}
	
	
	private func updateViews() {
		guard let receipt = receipt,
			let date = receipt.date else { return }
		
		let amountString = String(format: "$ %.2f", receipt.amountSpent)
		merchantLabel.text = receipt.merchant
		merchantLabel.textColor = .receiptLightGreen
		dateLabel.text = dateFormatter.string(from: date)
		amountSpentLabel.text = amountString
		amountSpentLabel.textColor = .receiptGray
	}
	
	
	private func setupViews() {
		viewDetails.textLabelColorsWhite(textLabel: amountSpentLabel)
	}
}

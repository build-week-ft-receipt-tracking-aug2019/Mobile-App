//
//  ReceiptTableViewCell.swift
//  Receipt Tracking
//
//  Created by Percy Ngan on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {


	// MARK: - OUTLETS
	@IBOutlet weak var merchantLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var amountSpentLabel: UILabel!

	var viewDetails = AddView()

	var receipt: ReceiptRepresentation? {
		didSet {
			updateViews()
		}
	}
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        return formatter
    }


	private func updateViews() {
		guard let receipt = receipt,
              let date = receipt.date,
               let amount = receipt.amountSpent else { return }
       
        let amountString = "$\(amount)"
		merchantLabel.text = receipt.merchant
		merchantLabel.textColor = .receiptLightGreen
		dateLabel.text = dateFormatter.string(from: date)
		categoryLabel.text = receipt.category
		amountSpentLabel.text = amountString
		amountSpentLabel.textColor = .receiptDarkGreen
	}

	private func setupViews() {

		viewDetails.textlabelColorsLightGreen(textLabel: amountSpentLabel)
	}
    
}

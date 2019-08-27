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


	var receipt: Receipt? {
		didSet {
			updateViews()
		}
	}
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy, h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        return formatter
    }

	private func updateViews() {
		guard let receipt = receipt,
              let date = receipt.date else { return }
        let amountString = String(receipt.amountSpent)

		merchantLabel.text = receipt.merchant
		dateLabel.text = dateFormatter.string(from: date)
		categoryLabel.text = receipt.category
		amountSpentLabel.text = amountString
	}
    
}

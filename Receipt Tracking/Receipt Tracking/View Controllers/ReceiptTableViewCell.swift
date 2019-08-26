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


	var receipt: ReceiptRepresentation? {

		didSet {
			updateViews()
		}
	}


	private func updateViews() {
		guard let receipt = receipt, let date = receipt.date, let amountSpent = receipt.amountSpent else { return }

		merchantLabel.text = receipt.merchant
		dateLabel.text = String(date)"
		categoryLabel.text = receipt.category
		amountSpentLabel.text = "\(amountSpent)"
	}

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

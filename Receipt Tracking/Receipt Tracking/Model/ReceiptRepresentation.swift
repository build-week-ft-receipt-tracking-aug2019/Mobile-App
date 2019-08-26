//
//  ReceiptRepresentation.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

struct ReceiptRepresentation: Codable {
    
    let merchant: String?
    let category: String?
    let amountSpent: Double?
    let date: Date?
    let identifier: String?
}

func ==(lhs: ReceiptRepresentation, rhs: Receipt) -> Bool {
    return lhs.merchant == rhs.merchant &&
        lhs.category == rhs.category &&
        lhs.amountSpent == rhs.amountSpent &&
        lhs.date == rhs.date &&
        lhs.identifier == rhs.identifier
}

func ==(lhs: Receipt, rhs: ReceiptRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: ReceiptRepresentation, rhs: Receipt) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Receipt, rhs: ReceiptRepresentation) -> Bool {
    return rhs != lhs
}

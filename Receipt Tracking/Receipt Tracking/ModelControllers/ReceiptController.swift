//
//  ModelControllers.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}

enum PutType: String {
    case add
    case update
}

class ReceiptController {
    
    static let shared = ReceiptController()
    
    let receiptURL = URL(string: "https://receipt-tracker-api.herokuapp.com/receipts")
    
}

//
//  Receipt+Convenience.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

enum Category: String, CaseIterable, Codable {
    case bills          = "Bills"
    case entertainment  = "Entertainment"
    case electronics    = "Electronics"
    case apparel        = "Apparel"
    case homeAppliances = "Home Appliances"
    case personalCare   = "Personal Care"
    case automobiles    = "Automobiles"
    case groceries      = "Groceries"
    case restaurant     = "Restaurant"
    case other          = "Other"
}

extension Receipt {
    
    @discardableResult convenience init( merchant: String, category: Category, amountSpent: Double, date: Date, identifier: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.merchant    = merchant
        self.category    = category.rawValue
        self.amountSpent = amountSpent
        self.date        = date
        self.identifier  = identifier
    }
    
    @discardableResult convenience init?(receiptRepresentation: ReceiptRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let merchant     = receiptRepresentation.merchant,
            let categoryString = receiptRepresentation.category,
            let amountSpent    = receiptRepresentation.amountSpent,
            let date           = receiptRepresentation.date,
            let identifier     = receiptRepresentation.identifier,
            let category       = Category(rawValue: categoryString) else { return nil }
        
        self.init(merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: identifier)
    }
    
    var receiptRepresentation: ReceiptRepresentation {
        return ReceiptRepresentation(merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: identifier)
    }
}

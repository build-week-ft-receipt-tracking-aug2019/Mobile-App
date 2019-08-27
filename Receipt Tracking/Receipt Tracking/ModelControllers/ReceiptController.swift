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
    let userController = UserController.shared
    
    
    let baseURL = URL(string: "https://receipt-tracker-api.herokuapp.com/users")!
    
    // MARK: - CRUD Methods
    
    // create
    func createReceipt(with merchant: String, category: Category, amountSpent: Double, date: Date, identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let receipt = Receipt(merchant: merchant, category: category, amountSpent: amountSpent, date: date)
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when creating new task:\(error)")
            }
            post(receipt: receipt)
        }
    }
    
    // update
    func updateReceipt(receipt: Receipt, with merchant: String, category: Category, amountSpent: Double, date: Date, identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            receipt.merchant    = merchant
            receipt.category    = category.rawValue
            receipt.amountSpent = amountSpent
            receipt.date        = date
            receipt.identifier  = identifier
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when updating receipt:\(error)")
            }
            put(receipt: receipt)
        }
    }
    
    // Update receipt with receiptRepresentation Method
    func update(receipt: Receipt, with receiptRepresentation: ReceiptRepresentation) {
        receipt.merchant    = receiptRepresentation.merchant
        receipt.category    = receiptRepresentation.category
        receipt.amountSpent = receiptRepresentation.amountSpent ?? 0.0
        receipt.date        = receiptRepresentation.date
        receipt.identifier  = receiptRepresentation.identifier
    }
    
    func deleteReceipt(receipt: Receipt, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        deleteReceiptFromServer(receipt: receipt)
        context.performAndWait {
            context.delete(receipt)
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when deleting receipt:\(error)")
            }
        }
    }
    
    func updatePersistentStore(forReceiptIn receiptRepresentations: [ReceiptRepresentation], for context: NSManagedObjectContext) {
        context.performAndWait {
            
            for receiptRep in receiptRepresentations {
                guard let identifier = receiptRep.identifier else { continue }
                
                if let receipt = self.fetchSingleReceiptFromPersistentStore(identifier: identifier, context: context) {
                    receipt.merchant    = receiptRep.merchant
                    receipt.category    = receiptRep.category
                    receipt.amountSpent = receiptRep.amountSpent ?? 0.0
                    receipt.date        = receiptRep.date
                    receipt.identifier  = receiptRep.identifier
                } else {
                    Receipt(receiptRepresentation: receiptRep, context: context)
                }
            }
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
    
    func post(receipt: Receipt, completion: @escaping () -> Void = { }) {
        guard let token = userController.token else { return }
        
        let requestURL     = baseURL.appendingPathComponent("receipts")
        var request        = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let receiptData    = try JSONEncoder().encode(receipt.receiptRepresentation)
            request.httpBody = receiptData
        } catch {
            NSLog("Error encoding receipt representation:\(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTing receipt to server:\(error)")
            }
            completion()
            }.resume()
    }
    
    // Delete receipt From Server Method
    func deleteReceiptFromServer(receipt: Receipt, completion: @escaping (NetworkError?) -> Void = { _ in }) {
        
        guard let token = userController.token else {
            completion(.otherError)
            return
        }
        
        let requestURL     = baseURL.appendingPathComponent("receipts")
        var request        = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")

        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting receipt:\(error)")
            }
            completion(nil)
            }.resume()
    }
    
    // Fetch SINGLE receipt From Server Method
    func fetchSingleReceiptFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Receipt? {
        
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        var receipt: Receipt? = nil
        context.performAndWait {
            do {
                receipt = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching receipt with identifier \(identifier):\(error)")
                receipt = nil
            }
        }
        return receipt
    }
    
    // Fetch ALL receipts From Server Method
    func fetchReceiptsFromServer(completion: @escaping() -> Void) {
        
        guard let token = userController.token else { return }
        
        let requestURL     = baseURL.appendingPathComponent("receipts")
        var request        = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching receipts from server:\(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("Error GETing data from all receipts")
                completion()
                return
            }
            
            do {
                let receiptsDictionary = try JSONDecoder().decode([String: ReceiptRepresentation].self, from: data)
                let receiptRepArray    = receiptsDictionary.map({ $0.value })
                let moc                = CoreDataStack.shared.container.newBackgroundContext()
                
                self.updatePersistentStore(forReceiptIn: receiptRepArray, for: moc)
            } catch {
                NSLog("error decoding receipts:\(error)")
            }
            completion()
            }.resume()
    }
    
}




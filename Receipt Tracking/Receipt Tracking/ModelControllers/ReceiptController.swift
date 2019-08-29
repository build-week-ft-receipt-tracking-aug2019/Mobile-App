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
    
    let baseURL = URL(string: "https://receipt-tracker-api.herokuapp.com/users")!
    
    
    // Create Receipt
    func createReceipt(merchant: String, category: String, amountSpent: Double, date: Date, username: String) {
        
        let receiptRepresentation = ReceiptRepresentation(merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: nil, username: username)
        
        post(receipt: receiptRepresentation)
    }
    
    // Update Receipt
    func updateTour(receipt: Receipt, merchant: String, category: String, amountSpent: Double, date: Date, identifier: Int32, username: String) {
        let receiptRepresentation = ReceiptRepresentation(merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: identifier)
        receipt.merchant = merchant
        receipt.category = category
        receipt.amountSpent = amountSpent
        receipt.date = date
        receipt.identifier = identifier
        receipt.username = username
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
        
        post(receipt: receiptRepresentation)
    }
    
    // Delete Receipt
    func deleteReceipt(receipt: Receipt) {
        let moc = CoreDataStack.shared.mainContext
        
        
        deleteReceiptFromServer(receipt: receipt)
        moc.delete(receipt)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func fetchReceiptsFromServer(username: String, completion: @escaping () -> Void = { }) {
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        
        let requestURL = baseURL.appendingPathComponent("receipts")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion()
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Bad response fetching receipts, response code: \(response.statusCode)")
                completion()
                return
            }
            
            if let error = error {
                NSLog("Error fetching receipts from server: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetching receipts from server")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let receiptRepresentations = try decoder.decode([ReceiptRepresentation].self, from: data)
                completion()
                self.updateReceipts(with: receiptRepresentations)
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error decoding receipt representations \(error)")
                completion()
                return
            }
            }.resume()
    }
    
    
    // Post Receipt
    func post(postReceipt: PostReceiptRepresentation, completion: @escaping () -> Void = { }) {
        let requestURL: URL = baseURL.appendingPathComponent("receipt")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(postReceipt)
        } catch {
            NSLog("Error encoding receipt \(postReceipt): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error POSTing receipt to server: \(error)")
                completion()
                return
            }
            
            guard let data = data else { return }
            do {
                let receiptID = try JSONDecoder().decode([Int].self, from: data)
                let moc = CoreDataStack.shared.mainContext
                moc.performAndWait {
                    guard let merchant = postReceipt.merchant,
                          let categoryString = postReceipt.category,
                          let category = Category.init(rawValue: categoryString),
                          let amountSpent = postReceipt.amountSpent,
                          let date = postReceipt.date,
                          let identifier = receiptID.first else { return }
                    let receipt = Receipt(merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: identifier)
                }
                
                try CoreDataStack.shared.save(context: moc)
            } catch {
                NSLog("Error decoding receipt and saving receipt: \(error)")
            }
            
            completion()
            }.resume()
    }
    
    func deleteReceiptFromServer(receipt: Receipt, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL: URL = baseURL.appendingPathComponent("receipts")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting tour from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    private func fetchSingleReceiptFromPersistentStore(identifier: Int32, context: NSManagedObjectContext) -> Receipt? {
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", identifier)
        
        var receipt: Receipt? = nil
        
        context.performAndWait {
            do {
                receipt = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching Receipt with identifier \(identifier): \(error)")
            }
        }
        
        return receipt
    }
    
    private func update(receipt: Receipt, receiptRepresentation: ReceiptRepresentation) {
        guard let amountSpent = receiptRepresentation.amountSpent,
            let identifier = receiptRepresentation.identifier else { return }
        receipt.merchant = receiptRepresentation.merchant
        receipt.category = receiptRepresentation.category
        receipt.amountSpent = amountSpent
        receipt.date = receiptRepresentation.date
        receipt.identifier = identifier
        receipt.username = receiptRepresentation.username
    }
    
    private func updateReceipts(with receiptRepresentations: [ReceiptRepresentation], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            for receiptRep in receiptRepresentations {
                guard let identifier = receiptRep.identifier else { return }
                let receipt = fetchSingleReceiptFromPersistentStore(identifier: identifier, context: context)
                
                if let receipt = receipt {
                    if receipt != receiptRep {
                        update(receipt: receipt, receiptRepresentation: receiptRep)
                    }
                } else {
                    Receipt(receiptRepresentation: receiptRep)
                }
            }
        }
    }
}

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
    func createReceipt(merchant: String, category: String, amountSpent: Double, date: Date, identifier: Int32, username: String) {
        
        let receiptRepresentation = ReceiptRepresentation(merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: identifier, username: username)
        
        post(receipt: receiptRepresentation)
    }
    
    // Update Receipt
    func updateTour(receipt: Receipt, merchant: String, category: String, amountSpent: Double, date: Date, identifier: Int32, username: String) {
        let receiptRepresentation = ReceiptRepresentation(merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: identifier, username: username)
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
                let receiptRepresentations = try JSONDecoder().decode([ReceiptRepresentation].self, from: data)
                
                self.updateReceipts(with: receiptRepresentations)
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error decoding entry representations \(error)")
                completion()
                return
            }
            }.resume()
    }
    
    
    // Post Receipt
    func post(receipt: ReceiptRepresentation, completion: @escaping () -> Void = { }) {
        let requestURL: URL = baseURL.appendingPathComponent("receipts")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(receipt)
        } catch {
            NSLog("Error encoding receipt \(receipt): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error PUTting receipt to server: \(error)")
                completion()
                return
            }
            
            guard let data = data else { return }
            do {
                let receiptID = try JSONDecoder().decode([Int].self, from: data)
                let moc = CoreDataStack.shared.mainContext
                moc.performAndWait {
                    let receipt = Receipt(receiptRepresentation: receipt)
                    guard let identifier = receiptID.first else { return }
                    receipt?.identifier = Int32(identifier)
                }
                
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error decoding tourID and saving tour: \(error)")
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














//static let shared = ReceiptController()
//let userController = UserController.shared
//
//
//let baseURL = URL(string: "https://receipt-tracker-api.herokuapp.com/users")!
//
//// MARK: - CRUD Methods
//
//// create
//func createReceipt(with merchant: String, category: Category, amountSpent: Double, date: Date, identifier: Int32, username: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//    context.performAndWait {
//        let receipt = Receipt(merchant: merchant, category: category, amountSpent: amountSpent, date: date, identifier: identifier, username: username)
//        do{
//            try CoreDataStack.shared.save(context: context)
//        } catch {
//            NSLog("Error saving context when creating new task:\(error)")
//        }
//        post(receipt: receipt)
//    }
//}
//
//// update
//func updateReceipt(receipt: Receipt, with merchant: String, category: Category, amountSpent: Double, date: Date, identifier: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//    context.performAndWait {
//        receipt.merchant    = merchant
//        receipt.category    = category.rawValue
//        receipt.amountSpent = amountSpent
//        receipt.date        = date
//        receipt.identifier  = identifier
//
//        do {
//            try CoreDataStack.shared.save(context: context)
//        } catch {
//            NSLog("Error saving context when updating receipt:\(error)")
//        }
//        post(receipt: receipt)
//    }
//}
//
//// Update receipt with receiptRepresentation Method
//func update(receipt: Receipt, with receiptRepresentation: ReceiptRepresentation) {
//    guard let id = receiptRepresentation.identifier else { return }
//    receipt.merchant    = receiptRepresentation.merchant
//    receipt.category    = receiptRepresentation.category
//    receipt.amountSpent = receiptRepresentation.amountSpent ?? 0.0
//    receipt.date        = receiptRepresentation.date
//    receipt.identifier  = id
//}
//
//func deleteReceipt(receipt: Receipt, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//    deleteReceiptFromServer(receipt: receipt)
//    context.performAndWait {
//        context.delete(receipt)
//
//        do {
//            try CoreDataStack.shared.save(context: context)
//        } catch {
//            NSLog("Error saving context when deleting receipt:\(error)")
//        }
//    }
//}
//
//func updatePersistentStore(forReceiptIn receiptRepresentations: [ReceiptRepresentation], for context: NSManagedObjectContext) {
//    context.performAndWait {
//
//        for receiptRep in receiptRepresentations {
//            guard let identifier = receiptRep.identifier else { continue }
//
//            if let receipt = self.fetchSingleReceiptFromPersistentStore(identifier: identifier, context: context) {
//                guard let id = receiptRep.identifier else { return }
//                receipt.merchant    = receiptRep.merchant
//                receipt.category    = receiptRep.category
//                receipt.amountSpent = receiptRep.amountSpent ?? 0.0
//                receipt.date        = receiptRep.date
//                receipt.identifier  = id
//            } else {
//                Receipt(receiptRepresentation: receiptRep, context: context)
//            }
//        }
//
//        do {
//            try CoreDataStack.shared.save(context: context)
//        } catch {
//            NSLog("Error saving context: \(error)")
//            context.reset()
//        }
//    }
//}
//
//func post(receipt: Receipt, completion: @escaping () -> Void = { }) {
//    guard let token = userController.token else { return }
//
//    let requestURL     = baseURL.appendingPathComponent("receipts")
//    var request        = URLRequest(url: requestURL)
//    request.httpMethod = HTTPMethod.put.rawValue
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue(token, forHTTPHeaderField: "Authorization")
//
//    do {
//        let receiptData    = try JSONEncoder().encode(receipt.receiptRepresentation)
//        request.httpBody = receiptData
//    } catch {
//        NSLog("Error encoding receipt representation:\(error)")
//        completion()
//        return
//    }
//
//    URLSession.shared.dataTask(with: request) { _, _, error in
//        if let error = error {
//            NSLog("Error PUTing receipt to server:\(error)")
//        }
//        completion()
//        }.resume()
//}
//
//// Delete receipt From Server Method
//func deleteReceiptFromServer(receipt: Receipt, completion: @escaping (NetworkError?) -> Void = { _ in }) {
//
//    guard let token = userController.token else {
//        completion(.otherError)
//        return
//    }
//
//    let requestURL     = baseURL.appendingPathComponent("receipts")
//    var request        = URLRequest(url: requestURL)
//    request.httpMethod = HTTPMethod.delete.rawValue
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue(token, forHTTPHeaderField: "Authorization")
//
//
//    URLSession.shared.dataTask(with: request) { (_, _, error) in
//        if let error = error {
//            NSLog("Error deleting receipt:\(error)")
//        }
//        completion(nil)
//        }.resume()
//}
//
//// Fetch SINGLE receipt From Server Method
//func fetchSingleReceiptFromPersistentStore(identifier: Int32, context: NSManagedObjectContext) -> Receipt? {
//
//    let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
//    fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
//    var receipt: Receipt? = nil
//    context.performAndWait {
//        do {
//            receipt = try context.fetch(fetchRequest).first
//        } catch {
//            NSLog("Error fetching receipt with identifier \(identifier):\(error)")
//            receipt = nil
//        }
//    }
//    return receipt
//}
//
//// Fetch ALL receipts From Server Method
//func fetchReceiptsFromServer(completion: @escaping() -> Void) {
//
//    guard let token = userController.token else { return }
//
//    let requestURL     = baseURL.appendingPathComponent("receipts")
//    var request        = URLRequest(url: requestURL)
//    request.httpMethod = HTTPMethod.delete.rawValue
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue(token, forHTTPHeaderField: "Authorization")
//
//    URLSession.shared.dataTask(with: request) { data, _, error in
//        if let error = error {
//            NSLog("Error fetching receipts from server:\(error)")
//            completion()
//            return
//        }
//
//        guard let data = data else {
//            NSLog("Error GETing data from all receipts")
//            completion()
//            return
//        }
//
//        do {
//            let receiptsDictionary = try JSONDecoder().decode([String: ReceiptRepresentation].self, from: data)
//            let receiptRepArray    = receiptsDictionary.map({ $0.value })
//            let moc                = CoreDataStack.shared.container.newBackgroundContext()
//
//            self.updatePersistentStore(forReceiptIn: receiptRepArray, for: moc)
//        } catch {
//            NSLog("error decoding receipts:\(error)")
//        }
//        completion()
//        }.resume()
//}


//
//  ImageController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/29/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    
    static let shared = ImageController()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM dd yy h mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func createImageName(from date: Date, merchant: String, amountSpent: Double) -> String {
        let dateString = dateFormatter.string(from: date)
        let amountSpentString = String(amountSpent)
        var imageName = dateString + merchant + amountSpentString
         imageName = imageName.replacingOccurrences(of: ".", with: "")
        let completeImageName = imageName.replacingOccurrences(of: " ", with: "")
        return completeImageName
    }
    
    func saveImage(image: UIImage, fileName: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(fileName).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func deleteImage(imageName: String) {
        let imagePath = documentsPath.appendingPathComponent(imageName)
        
        guard fileManager.fileExists(atPath: imagePath.path) else {
            print("Image does not exist at path: \(imagePath)")
            
            return
        }
        
        do {
            try fileManager.removeItem(at: imagePath)
            
            print("\(imageName) was deleted.")
        } catch let error as NSError {
            print("Could not delete \(imageName): \(error)")
        }
    }
    
    
}

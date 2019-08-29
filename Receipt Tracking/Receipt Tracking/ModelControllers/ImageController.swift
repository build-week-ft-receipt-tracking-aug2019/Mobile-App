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
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func saveImage(image: UIImage, from: Date, merchant: String, amountSpent: Double) {
        let date = String( Date.timeIntervalSinceReferenceDate )
        var imageName = date.replacingOccurrences(of: ".", with: "-")
        let amountSpentString = String(amountSpent)
        imageName.append(contentsOf: merchant)
        imageName.append(contentsOf: amountSpentString)
        let completeImageName = imageName + ".jpg"
        if let imageData = image.pngData() {
            do {
                let filePath = documentsPath.appendingPathComponent(imageName)
                
                try imageData.write(to: filePath)
                
                print("\(completeImageName) was saved.")
                
            } catch let error as NSError {
                print("\(completeImageName) could not be saved: \(error)")
                
            }
            
        } else {
            print("Could not convert UIImage to png data.")
        }
    }
    
    func fetchImage(imageName: String) -> UIImage? {
        let imagePath = documentsPath.appendingPathComponent(imageName).path
        
        guard fileManager.fileExists(atPath: imagePath) else {
            print("Image does not exist at path: \(imagePath)")
            
            return nil
        }
        
        if let imageData = UIImage(contentsOfFile: imagePath) {
            return imageData
        } else {
            print("UIImage could not be created.")
            
            return nil
        }
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

//
//  AddReceiptViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class AddReceiptViewController: UIViewController {
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var merchantTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
    
    private func setViews() {
        
    }
    
    @IBAction func uploadPhotoButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }
    
}

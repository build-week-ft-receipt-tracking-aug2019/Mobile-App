//
//  EditReceiptViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class EditReceiptViewController: UIViewController {
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var editPhotoButton: UIButton!
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
    
    @IBAction func editPhotoButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
}

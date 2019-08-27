//
//  LoginViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//
import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties
    
    var loginView = LoginView()
    let userController = UserController.shared
    var isLogin: Bool = false
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    private func setViews() {
        
        loginView.textFieldConfiguration(textField: emailTextField)
        loginView.textFieldConfiguration(textField: usernameTextField)
        loginView.textFieldConfiguration(textField: passwordTextField)
        loginView.buttonConfiguration(button: loginButton)
        loginView.currentViewConfiguration(view: view)
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        loginButton.setTitle("Register", for: .normal)
    }
    



}

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
    
    var loginView = LoginView()
    
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
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

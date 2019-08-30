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
	var isLogin: Bool = true
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var forgotPasswordButton: UIButton!
	@IBOutlet weak var signUpButton: UIButton!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var emailTextField: UITextField!
	

	// MARK: - View LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setViews()
		isLogin = true
	}
	
	
	private func setViews() {
		loginView.textFieldConfiguration(textField: emailTextField)
		loginView.textFieldConfiguration(textField: usernameTextField)
		loginView.textFieldConfiguration(textField: passwordTextField)
		loginView.buttonConfiguration(button: loginButton)
		loginView.currentViewConfiguration(view: view)
	}
	
	
	@IBAction func loginButtonTapped(_ sender: UIButton) {
		if isLogin {
			login()
		} else {
			register()
		}
	}
	
	
	@IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
	}
	
	
	@IBAction func signUpButtonTapped(_ sender: UIButton) {
		loginButton.setTitle("Register", for: .normal)
		isLogin = false
	}
	
	
	// MARK: - Methods
	func login() {
		let check = completeFieldsChecker()
		if check == true {
			guard let username = usernameTextField.text,
				!username.isEmpty,
				let email = emailTextField.text,
				!email.isEmpty,
				let password = passwordTextField.text,
				!password.isEmpty else { return }
			
			let user = UserRepresentation(username: username, password: password, email: email)
			userController.loginWith(user: user, loginType: .signIn) { (result) in
				if (try? result.get()) != nil {
					DispatchQueue.main.async {
						self.dismiss(animated: true, completion: nil)
					}
				} else {
					NSLog("Error logging in with \(result)")
				}
			}
		} else {
			return
		}
	}
	
	
	func register() {
		let check = completeFieldsChecker()
		if check == true {
			guard let username = usernameTextField.text,
				!username.isEmpty,
				let email = emailTextField.text,
				!email.isEmpty,
				let password = passwordTextField.text,
				!password.isEmpty else { return }
			
			let user = UserRepresentation(username: username, password: password, email: email)
			userController.registerWith(user: user, loginType: .signUp) { (error) in
				if let error = error {
					NSLog("Error registering with \(error)")
				}
				self.userController.loginWith(user: user, loginType: .signIn) { (result) in
					if (try? result.get()) != nil {
						DispatchQueue.main.async {
							self.dismiss(animated: true, completion: nil)
						}
					} else {
						NSLog("Error logging in with \(result)")
					}
				}
			}
		}
	}
	
	
	func completeFieldsChecker() -> Bool{
		
		let title: String = "Oops!"
		var message: String?
		var checker: Bool = false
		
		if let username = usernameTextField.text,
			let email = emailTextField.text,
			let password = passwordTextField.text {
			if username.isEmpty && isLogin == false {
				message = "Please enter your name."
			} else if email.isEmpty || email.contains("@") == false {
				message = "Please enter a valid email."
			} else if password.isEmpty {
				message = "Please enter your password"
			} else if password.count < 5 {
				message = "Your password must be at least 5 characters long."
			} else {
				checker = true
			}
		}
		
		if checker == false {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true)
		}
		return checker
	}
}

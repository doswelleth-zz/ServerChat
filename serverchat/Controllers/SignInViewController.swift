//
//  SignInViewController.swift
//  serverchat
//
//  Created by David Oliver Doswell on 2/6/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

let signInText = "Sign In 😎"

private let emailPlaceholder = "email"
private let passwordPlaceholder = "secret"

class SignInViewController: UIViewController {
    
    let backButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle("🏃‍♂️", for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        return button
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.appColor()
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.appColor()
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(signInText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = UIColor.appColor()
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signInButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    @objc func backButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { view.endEditing(true) }
    
    @objc func signInButtonTap(sender: UIButton) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            presentEmptyFieldsAlert()
        } else {
            guard let email = emailTextField.text, let password = passwordTextField.text else  { return }
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    print("ERROR: ", error?.localizedDescription as Any)
                    return
                }
                let destination = MessageTableViewController()
                self.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
    
    func presentEmptyFieldsAlert() {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alert = UIAlertController(title: emptyFieldsAlertTitle, message: emptyFieldsMessageTitle, preferredStyle: .alert)
            let action = UIAlertAction(title: emptyFieldsActionTitle, style: .default, handler: { (action) in
                // Dismiss controller
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentSignInError() {
        let alert = UIAlertController(title: signInErrorAlertTitle, message: signInErrorMessageTitle, preferredStyle: .alert)
        let action = UIAlertAction(title: signInErrorActionTitle, style: .default, handler: { (action) in
            // Dismiss controller
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private let emptyFieldsAlertTitle = "Whoops 😮"
    private let emptyFieldsMessageTitle = "Please enter all fields correctly"
    private let emptyFieldsActionTitle = "Okay"
    
    private let signInErrorAlertTitle = "Blerg 🤪"
    private let signInErrorMessageTitle = "Enter your email and password"
    private let signInErrorActionTitle = "Heard"
    
    func setUpViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        
        let margin = view.layoutMarginsGuide
        
        // Back button constraints
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .leftMargin, multiplier: 1, constant: 20)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .topMargin, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        // Email textfield constraints
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .topMargin, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        // Password textfield constraints
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .bottom, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        // Join button constraints
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .bottom, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            emailTextField.resignFirstResponder()
        }
        return true
    }
}


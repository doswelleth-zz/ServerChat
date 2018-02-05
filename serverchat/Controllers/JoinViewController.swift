//
//  JoinViewController.swift
//  serverchat
//
//  Created by David Oliver Doswell on 2/3/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

let joinText = "Join Us 🎉"
let loginText = "Login 😎"

private let namePlaceHolder = "first name (add emoji 🐒)"
private let emailPlaceholder = "email"
private let passwordPlaceholder = "secret"

class JoinViewController: UIViewController {
    
    var messagesTableViewController: MessageTableViewController?
    
    lazy var serverImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Preview")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(serverImageTap)))
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.appColor()
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(string: namePlaceHolder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
    
    let joinButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(joinText, for: .normal)
        button.setTitleColor(UIColor.appColor(), for: .normal)
        button.layer.borderColor = UIColor.appColor().cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(joinTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(loginText, for: .normal)
        button.setTitleColor(UIColor.appColor(), for: .normal)
        button.layer.borderColor = UIColor.appColor().cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { view.endEditing(true) }
    
    // Login
    @objc func loginButtonTap(sender: UIButton) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            presentJoinAlert()
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
    
    func presentJoinAlert() {
        if nameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alert = UIAlertController(title: alertTitle, message: messageTitle, preferredStyle: .alert)
            let action = UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
                // Dismiss controller
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private let alertTitle = "Whoops 😮"
    private let messageTitle = "Please enter all fields correctly"
    private let actionTitle = "Okay"
    
    func setUpViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(serverImage)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(joinButton)
        view.addSubview(loginButton)
        
        let margin = view.layoutMarginsGuide
        
        // Server image constraints
        view.addConstraints([NSLayoutConstraint(item: serverImage, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: serverImage, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .top, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: serverImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: serverImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)])
        
        // First name textfield constraints
        view.addConstraints([NSLayoutConstraint(item: nameTextField, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: nameTextField, attribute: .bottom, relatedBy: .equal, toItem: serverImage, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: nameTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        
        // Email textfield constraints
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .bottom, relatedBy: .equal, toItem: nameTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        // Password textfield constraints
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .bottom, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        // Join button constraints
        view.addConstraints([NSLayoutConstraint(item: joinButton, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .leftMargin, multiplier: 1, constant: 20)])
        
        view.addConstraints([NSLayoutConstraint(item: joinButton, attribute: .bottom, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: joinButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        view.addConstraints([NSLayoutConstraint(item: joinButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        // Login button constraints
        view.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: margin, attribute: .rightMargin, multiplier: 1, constant: -20)])
        
        view.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .bottom, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 75)])
        
        view.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        view.addConstraints([NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension JoinViewController: UITextFieldDelegate {
    
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

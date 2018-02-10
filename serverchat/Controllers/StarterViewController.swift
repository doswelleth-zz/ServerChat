//
//  StarterViewController.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/22/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

private let serverChatTitle = "Server Chat"
private let serverChatSubtitleTitle = "A Place Where Servers Chat"
private let signInButtonText = "Sign In"
private let eulaButtonTitle = "License Agreement"

class StarterViewController: UIViewController {
        
    let serverChat : UILabel = {
        let label = UILabel()
        label.text = serverChatTitle
        label.textColor = UIColor.appColor()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let serverChatSubtitle : UILabel = {
        let label = UILabel()
        label.text = serverChatSubtitleTitle
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let serverLogo : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Icon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(signInButtonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor.appColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signInButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let eulaAgreement : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(eulaButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(eulaTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc func signInButtonTap(sender: UIButton) {
        if Auth.auth().currentUser?.uid != nil {
            let destination = MessageTableViewController()
            self.navigationController?.pushViewController(destination, animated: true)
        } else {
            let destination = JoinViewController()
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    @objc func eulaTap(sender: UIButton) {
        let destination = EulaViewController()
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(serverChat)
        view.addSubview(serverChatSubtitle)
        view.addSubview(serverLogo)
        view.addSubview(signInButton)
        view.addSubview(eulaAgreement)
        
        let margin = view.layoutMarginsGuide
        
        // Server chat constraints
        view.addConstraints([NSLayoutConstraint(item: serverChat, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChat, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .topMargin, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChat, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChat, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        // Server chat subtitle constraints
        view.addConstraints([NSLayoutConstraint(item: serverChatSubtitle, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChatSubtitle, attribute: .bottom, relatedBy: .equal, toItem: serverChat, attribute: .bottom, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChatSubtitle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChatSubtitle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)])
        
        // Server logo constraints
        view.addConstraints([NSLayoutConstraint(item: serverLogo, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: serverLogo, attribute: .centerY, relatedBy: .equal, toItem: margin, attribute: .centerY, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: serverLogo, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)])
        
        view.addConstraints([NSLayoutConstraint(item: serverLogo, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)])
        
        // Sign in button constraints
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .bottom, relatedBy: .equal, toItem: serverLogo, attribute: .bottom, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125)])
        
        view.addConstraints([NSLayoutConstraint(item: signInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        // Eula Agreement button constraints
        view.addConstraints([NSLayoutConstraint(item: eulaAgreement, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: eulaAgreement, attribute: .bottom, relatedBy: .equal, toItem: signInButton, attribute: .bottom, multiplier: 1, constant: 30)])
        
        view.addConstraints([NSLayoutConstraint(item: eulaAgreement, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)])
        
        view.addConstraints([NSLayoutConstraint(item: eulaAgreement, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 17)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



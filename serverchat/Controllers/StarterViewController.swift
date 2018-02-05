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
    
    lazy var serverLogo : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Icon")
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(sender:))))
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    @objc func imageTap(sender: UIButton) {
        if Auth.auth().currentUser?.uid != nil {
            let destination = MessageTableViewController()
            self.navigationController?.pushViewController(destination, animated: true)
        } else {
        let destination = JoinViewController()
        self.navigationController?.pushViewController(destination, animated: true)
        }
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
        view.addSubview(serverLogo)
        
        let margin = view.layoutMarginsGuide
        
        // Server chat constraints
        view.addConstraints([NSLayoutConstraint(item: serverChat, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChat, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .topMargin, multiplier: 1, constant: 100)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChat, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: serverChat, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
        
        // Server logo constraints
        view.addConstraints([NSLayoutConstraint(item: serverLogo, attribute: .centerX, relatedBy: .equal, toItem: margin, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: serverLogo, attribute: .centerY, relatedBy: .equal, toItem: margin, attribute: .centerY, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint(item: serverLogo, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)])
        
        view.addConstraints([NSLayoutConstraint(item: serverLogo, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  EulaViewController.swift
//  serverchat
//
//  Created by David Oliver Doswell on 2/9/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

private let softwareAgreementText = "License Agreement"
private let backButtonTitle = "🏃‍♀️"

class EulaViewController: UIViewController {
    
    let backButton : UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle(backButtonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    let softwareAgreementLabel : UILabel = {
        let label = UILabel()
        label.text = softwareAgreementText
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let EULATextView : UITextView = {
        let textView = UITextView()
        textView.text = EULA().agreement
        textView.allowsEditingTextAttributes = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textAlignment = .justified
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }
    
    @objc func backButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(softwareAgreementLabel)
        view.addSubview(EULATextView)
        
        let margin = view.layoutMarginsGuide
      
        // Back button constraints
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .leftMargin, multiplier: 1, constant: 20)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: margin, attribute: .topMargin, multiplier: 1, constant: 10)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        view.addConstraints([NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        
        // Software label constraints
        view.addConstraints([NSLayoutConstraint(item: softwareAgreementLabel, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .leftMargin, multiplier: 1, constant: 20)])
        
        view.addConstraints([NSLayoutConstraint(item: softwareAgreementLabel, attribute: .top, relatedBy: .equal, toItem: backButton, attribute: .topMargin, multiplier: 1, constant: 50)])
        
        view.addConstraints([NSLayoutConstraint(item: softwareAgreementLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: softwareAgreementLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)])
        
        // EULA Agreements constraints
        view.addConstraints([NSLayoutConstraint(item: EULATextView, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .leftMargin, multiplier: 1, constant: 20)])
        
        view.addConstraints([NSLayoutConstraint(item: EULATextView, attribute: .top, relatedBy: .equal, toItem: softwareAgreementLabel, attribute: .topMargin, multiplier: 1, constant: 40)])
        
        view.addConstraints([NSLayoutConstraint(item: EULATextView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)])
        
        view.addConstraints([NSLayoutConstraint(item: EULATextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 500)])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  UsersCell.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/24/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

class UsersCell: UITableViewCell {
    
    let serverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let serverNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let serverDetailLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let serverTimeLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var message: Message? {
        didSet {
            setUpNameAndServerImage()
            serverDetailLabel.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                serverTimeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    private func setUpNameAndServerImage() {
        if let id = message?.chatPartnerID {
            let ref = Database.database().reference().child("users").child(id()!)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.serverNameLabel.text = dictionary["name"] as? String
                    if let serverImageURL = dictionary["serverImageURL"] {
                        self.serverImageView.cacheImage(urlString: (serverImageURL as! String))
                    }
                }
            }, withCancel: nil)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        addSubview(serverImageView)
        addSubview(serverNameLabel)
        addSubview(serverDetailLabel)
        addSubview(serverTimeLabel)
        
        let margin = layoutMarginsGuide
        
        // Server image constraints
        addConstraints([NSLayoutConstraint(item: serverImageView, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .leftMargin, multiplier: 1, constant: 5)])
        
        addConstraints([NSLayoutConstraint(item: serverImageView, attribute: .centerY, relatedBy: .equal, toItem: margin, attribute: .centerY, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: serverImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        addConstraints([NSLayoutConstraint(item: serverImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        // Server name label constraints
        addConstraints([NSLayoutConstraint(item: serverNameLabel, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .leftMargin, multiplier: 1, constant: 65)])
        
        addConstraints([NSLayoutConstraint(item: serverNameLabel, attribute: .centerY, relatedBy: .equal, toItem: margin, attribute: .centerY, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: serverNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)])
        
        addConstraints([NSLayoutConstraint(item: serverNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        // Server time label constraints
        addConstraints([NSLayoutConstraint(item: serverTimeLabel, attribute: .right, relatedBy: .equal, toItem: margin, attribute: .right, multiplier: 1, constant: -5)])
        
        addConstraints([NSLayoutConstraint(item: serverTimeLabel, attribute: .centerY, relatedBy: .equal, toItem: margin, attribute: .centerY, multiplier: 1, constant: 0)])
        
        addConstraints([NSLayoutConstraint(item: serverTimeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)])
        
        addConstraints([NSLayoutConstraint(item: serverTimeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)])
        
        // Server detail label constraints
        addConstraints([NSLayoutConstraint(item: serverDetailLabel, attribute: .left, relatedBy: .equal, toItem: margin, attribute: .leftMargin, multiplier: 1, constant: 65)])
        
        addConstraints([NSLayoutConstraint(item: serverDetailLabel, attribute: .bottom, relatedBy: .equal, toItem: serverNameLabel, attribute: .bottom, multiplier: 1, constant: 10)])
        
        addConstraints([NSLayoutConstraint(item: serverDetailLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)])
        
        addConstraints([NSLayoutConstraint(item: serverDetailLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)])
    }
}


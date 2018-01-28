//
//  ServerChatCell.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/28/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

class ServerChatCell: UICollectionViewCell {
    
    let bubbleView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let chatTextView : UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        backgroundColor = .black
        
        addSubview(bubbleView)
        addSubview(chatTextView)
        
        // Bubble text view constraints
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Chat text view constraints
        chatTextView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        chatTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chatTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        chatTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
}











//
//  ServerChatCell.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/28/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

class ServerChatCell: UICollectionViewCell {
    
    var serverChatController : ServerChatController?
    
    let bubbleView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let chatTextView : UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let serverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var messageImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomTap)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func zoomTap(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            self.serverChatController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
    func setUpViews() {
        backgroundColor = .black
        
        addSubview(bubbleView)
        addSubview(chatTextView)
        addSubview(serverImageView)
        
        bubbleView.addSubview(messageImageView)
       
        // Server image view constraints
        serverImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        serverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        serverImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        serverImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // Bubble text view constraints
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true

        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.serverImageView.rightAnchor, constant: 8)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Message image constraints
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        // Chat text view constraints
        chatTextView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        chatTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chatTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        chatTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
}











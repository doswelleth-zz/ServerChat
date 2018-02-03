//
//  ServerChatInputContainerView.swift
//  serverchat
//
//  Created by David Oliver Doswell on 2/2/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

private let sendButtonTitle = "Send"
private let inputTextFieldPlaceholder = "New message"

class ServerChatInputContainerView: UIView, UITextFieldDelegate {
    
    var serverChatController : ServerChatController? {
        didSet {
            sendButton.addTarget(serverChatController, action: #selector(serverChatController?.sendButtonTap), for: .touchUpInside)
            
            uploadImageButton.addTarget(serverChatController, action: #selector(serverChatController?.handleUpLoad), for: .touchUpInside)
        }
    }

    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.clearsOnBeginEditing = true
        textField.attributedPlaceholder = NSAttributedString(string: inputTextFieldPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        textField.textColor = .white
        textField.tintColor = .white
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let uploadImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Upload"), for: .normal)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(sendButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let separatorLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        serverChatController?.sendButtonTap()
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpContainerView()
    }

    func setUpContainerView() {
        
        backgroundColor = .black
    
        // Upload button constraints
        addSubview(uploadImageButton)
        uploadImageButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // Send button constraints
        addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // Input textfield constraints
        addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: uploadImageButton.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // Separator constraints
        addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

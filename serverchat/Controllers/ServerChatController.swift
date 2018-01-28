//
//  ServerChatController.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/25/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "reuseIdentifier"
private let sendButtonTitle = "Send"
private let inputTextFieldPlaceholder = "New message"

class ServerChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            self.navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    // Input textfield class reference
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.clearsOnBeginEditing = true
        textField.attributedPlaceholder = NSAttributedString(string: inputTextFieldPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        textField.textColor = .white
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black

        // Customize nav bar items
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTap(sender:)))
        
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        self.collectionView?.register(ServerChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        setUpInputComponents()
    }
    
    @objc func backTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userMessageReference = Database.database().reference().child("user-messages").child(uid)
        userMessageReference.observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageID)
            messagesRef.observe(.value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if message.chatPartnerID() == self.user?.id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { collectionView?.endEditing(true) }
    
    // Data source
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].text {
            height = estimatedFrameForText(text: text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ServerChatCell
        
        let message = messages[indexPath.item]
        cell.chatTextView.text = message.text
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 32
        return cell
    }
    
    func setUpInputComponents( ) {
        
        // Container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Send button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle(sendButtonTitle, for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTap), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Input textfield constraints
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Separator
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = .white
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo:  containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    @objc func sendButtonTap() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toUserID = user!.id!
        let fromUserID = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text" : inputTextField.text!, "toUserID" : toUserID, "fromUserID" : fromUserID, "timestamp" : timestamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
            }
            self.inputTextField.text = nil
            let userMessageRef = Database.database().reference().child("user-messages").child(fromUserID)
            
            let messageID = childRef.key
            userMessageRef.updateChildValues([messageID: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toUserID)
            recipientUserMessagesRef.updateChildValues([messageID: 1])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTap()
        return true
    }
}

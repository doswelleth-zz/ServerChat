//
//  MessageTableViewController.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/20/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "reuseIdentifier"

class MessageTableViewController: UITableViewController {
    
    let ref = Database.database().reference(withPath: "messages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        // Customize nav bar items
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitTap(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(createNewMessage(sender:)))
        
        navigationController?.hidesBarsOnTap = false
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        // Customize tableview items
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UsersCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        checkIfServerIsLoggedIn()
    }
    
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    
    func retrieveUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userID = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userID).observe(.childAdded, with: { (snapshot) in
                
                let messageID = snapshot.key
                self.fetchMessageWithMessageID(messageID: messageID)
                
            }, withCancel: nil)
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptToReloadTable()
        
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    private func fetchMessageWithMessageID(messageID: String) {
        let messageReference = Database.database().reference().child("messages").child(messageID)
        messageReference.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let message = Message(dictionary: dictionary)                
                if let chatPartnerID = message.chatPartnerID() {
                    self.messagesDictionary[chatPartnerID] = message
                }
                self.attemptToReloadTable()
            }
        }, withCancel: nil)
    }
    
    private func attemptToReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp!.intValue > message2.timestamp!.intValue
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func exitTap(sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let serverError {
            print(serverError)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func createNewMessage(sender: UIButton) {
        let newMessageTableViewController = NewMessageTableViewController()
        newMessageTableViewController.messagesTableViewController = self
        self.navigationController?.pushViewController(newMessageTableViewController, animated: true)
    }
    
    func checkIfServerIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(exitTap(sender:)), with: nil, afterDelay: 0)
        } else {
            setNavBarTitleToCurrentServer()
        }
    }
    
    func setNavBarTitleToCurrentServer() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setUpNavBarWithUser(user: user)
            }
        }
    }
    
    func setUpNavBarWithUser(user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        retrieveUserMessages()
        
        // Title view
        let titleView = UIView()
        titleView.widthAnchor.constraint(equalToConstant: 175).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Constraints
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        
        // Server image
        let serverImageView = UIImageView()
        containerView.addSubview(serverImageView)
        
        serverImageView.contentMode = .scaleAspectFill
        serverImageView.layer.cornerRadius = 20
        serverImageView.layer.masksToBounds = true
        serverImageView.translatesAutoresizingMaskIntoConstraints = false
        if let serverImageURL = user.serverImageURL {
            serverImageView.cacheImage(urlString: serverImageURL)
        }
        
        serverImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        serverImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        serverImageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        serverImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        
        // Server name label
        let serverNameLabel = UILabel()
        containerView.addSubview(serverNameLabel)
        
        serverNameLabel.text = user.name
        serverNameLabel.textColor = .white
        serverNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        serverNameLabel.leftAnchor.constraint(equalTo: serverImageView.rightAnchor, constant: 8).isActive = true
        serverNameLabel.centerYAnchor.constraint(equalTo: serverImageView.centerYAnchor).isActive = true
        serverNameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        serverNameLabel.heightAnchor.constraint(equalTo: serverImageView.heightAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func serverChatTap(user: User) {
        let layout = UICollectionViewFlowLayout()
        let serverChatController = ServerChatController(collectionViewLayout: layout)
        serverChatController.user = user
        self.navigationController?.pushViewController(serverChatController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatPartnerID = message.chatPartnerID()
        
        let ref = Database.database().reference().child("users").child(chatPartnerID!)
        ref.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            let user = User()
            user.id = chatPartnerID
            user.setValuesForKeys(dictionary)
            self.serverChatTap(user: user)
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UsersCell
        
        let message = messages[indexPath.row]
        cell.message = message
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        let message = self.messages[indexPath.row]
        
        if let chatPartnerID = message.chatPartnerID() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerID).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                self.messagesDictionary.removeValue(forKey: chatPartnerID)
                self.attemptToReloadTable()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

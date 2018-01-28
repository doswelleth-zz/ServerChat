//
//  NewMessageTableViewController.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/22/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "reuseIdentifier"

class NewMessageTableViewController: UITableViewController {
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelButtonTap(sender:)))
        
        tableView.register(UsersCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        fetchUser()
    }
    
    @objc func cancelButtonTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var messagesTableViewController: MessageTableViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        self.messagesTableViewController?.serverChatTap(user: user)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UsersCell
        
        let user = users[indexPath.row]
        cell.serverNameLabel.text = user.name
        cell.serverImageView.contentMode = .scaleAspectFill
        
        if let serverImageURL = user.serverImageURL {
            cell.serverImageView.cacheImage(urlString: serverImageURL)
        }
        
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        
        return cell
    }
    
    func showServerChatControllerWithUser(user: User) {
        let layout = UICollectionViewFlowLayout()
        let destination = ServerChatController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
}

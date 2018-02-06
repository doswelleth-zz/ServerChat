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
    var filteredUsers = [User]()

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "🏃‍♀️", style: .plain, target: self, action: #selector(backButtonTap(sender:)))
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find Servers"
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UsersCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        fetchUser()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter({( user : User) -> Bool in
            return user.name!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    @objc func backButtonTap(sender: UIButton) {
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
        let user : User
        
        if isFiltering() {
            user = filteredUsers[indexPath.row]
            self.messagesTableViewController?.serverChatTap(user: user)
        } else {
            user = users[indexPath.row]
            self.messagesTableViewController?.serverChatTap(user: user)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredUsers.count
        }
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UsersCell
        
        let user : User
        
        if isFiltering() {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        cell.serverNameLabel.text = user.name
        cell.serverImageView.contentMode = .scaleAspectFill
        
        if let serverImageURL = user.serverImageURL {
            cell.serverImageView.cacheImage(urlString: serverImageURL)
        }
        
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        
        return cell
    }
    
    func showServerChatControllerWithUser(user: User) {
        let layout = UICollectionViewFlowLayout()
        let destination = ServerChatController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
}

extension NewMessageTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

//
//  FindFriendsViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/7/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import Kingfisher

class FindFriendsViewController: UIViewController {
    
    var users = [User](){
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
//        UserService.usersExcludingCurrentUser { (users) in
//            self.users = users
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FindFriendsViewController{
    func configureView() {
        applyKeyboardDismisser()
    }
}

extension FindFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendCell", for: indexPath) as! FindFriendCell
        let friend = users[indexPath.row]
        cell.usernameLabel.text = friend.username
        cell.nameLabel.text = "\(friend.firstName) \(friend.lastName)"
        if let url = friend.profileURL {
            let imageURL = URL(string: url)
            cell.profileImageView.kf.setImage(with: imageURL)
        }
        
        return cell
    }
}

extension FindFriendsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        checkForUsers() { (users) in
            self.users = users
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        checkForUsers() { (users) in
            self.users = users
        }
    }
    
    func checkForUsers(completion: @escaping ([User]) -> Void){
        guard let text = searchBar.text,
            !text.isEmpty else {
                return completion([])
        }
        
        UserService.usersBySearch(text: text) { (users) in
            completion(users)
        }
    }
}

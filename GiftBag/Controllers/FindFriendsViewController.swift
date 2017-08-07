//
//  FindFriendsViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/7/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToFindFriends(_ segue: UIStoryboardSegue) {
        print("Returned to Find Friends Controller!")
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toFriendRequest" {
                let friendRequestViewController = segue.destination as! FriendRequestViewController
                guard let indexPath = tableView.indexPathForSelectedRow else {
                    SCLAlertView().genericError()
                    return
                }
                friendRequestViewController.friend = users[indexPath.row]
                print("To Friend Request Screen!")
            }
        }
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
        else {
            cell.profileImageView.image = UIImage(named: "defaultProfile")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFriendRequest", sender: self)
    }
}

extension FindFriendsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        checkForUsers() { (users) in
            self.users = users
            print("finished check for users: \(users.count) users")
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        checkForUsers() { (users) in
            self.users = users
            print("finished check for users: \(users.count) users")
        }
    }
    
    func checkForUsers(completion: @escaping ([User]) -> Void){
        guard let text = searchBar.text,
            !text.isEmpty,
            !(text.trimmingCharacters(in: .whitespaces) == "") else {
                return completion([])
        }
        
        UserService.usersBySearch(text: text) { (users) in
            completion(users)
        }
    }
}

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFriendRequest", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        let cell = self.tableView.cellForRow(at: indexPath) as! FriendCell
        if(cell.selectionStyle == .none){
            return nil;
        }
        return indexPath;
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return requestActions(indexPath)
    }
    
    func requestActions(_ indexPath : IndexPath) -> [UITableViewRowAction]{
        let currentCell = tableView.cellForRow(at: indexPath) as! FriendCell
        let send = UITableViewRowAction(style: .normal, title: "Send") { [unowned self] (style, indexPath) in
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                print("0.1")
                currentCell.loadingView.startAnimating()
                currentCell.selectionStyle = .none
                let user = self.users[indexPath.row]
                FriendService.sendFriendRequest(to: user) { (success) in
                    if success {
                        SCLAlertView().showSuccess("Success!", subTitle: "Friend Request has been sent to \(user.username)")
                    }
                    currentCell.loadingView.stopAnimating()
                    currentCell.selectionStyle = .default
                    self.tableView.reloadData()
                }
            }
            print("0.0")
            self.tableView.reloadData()
        }
        send.backgroundColor = UIColor(red: 0.40, green: 1.00, blue: 0.40, alpha: 1.0)
        return [send]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let currentCell = tableView.cellForRow(at: indexPath) as! FriendCell? else {
            return true
        }
        if currentCell.loadingView.isAnimating {
            return false
        }
        return true
    }
}

extension FindFriendsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
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

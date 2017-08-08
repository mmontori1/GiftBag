//
//  FriendsViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/8/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    var requests : [Int] = [1,2]
    var friends : [Int] = [1,2,3,4]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FriendsViewController : UITableViewDataSource {
    enum Section : Int {
        case requests = 0, friends
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
            case .requests:
                return requests.count
            case .friends:
                return friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
            case .requests:
                let friendRequestCell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath as IndexPath) as! FriendRequestCell;
                friendRequestCell.backgroundColor = UIColor.yellow
                return friendRequestCell
            case .friends:
                let friendCell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath as IndexPath) as! FriendCell;
                friendCell.backgroundColor = UIColor.blue
                return friendCell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            return "..."
        }
        switch section {
            case .requests:
                return "Friend Requests"
            case .friends:
                return "Friends"
        }
    }
}

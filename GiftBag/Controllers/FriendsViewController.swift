//
//  FriendsViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/8/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    var requests = [User](){
        didSet{
            tableView.reloadData()
        }
    }
    var friends : [Int] = [1]
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FriendsViewController {
    func configureView(){
        refreshControl.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.alwaysBounceVertical = true
    }
    
    func reloadTable(){
        FriendService.showFriendRequests(for: User.current) { (users) in
            self.requests = users
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension FriendsViewController : UITableViewDataSource, UITableViewDelegate {
    enum Section : Int {
        case requests = 0, friends
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if requests.isEmpty {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = checkForRequests(section: section)
        guard let section = Section(rawValue: sections) else {
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
        let sections = checkForRequests(section: indexPath.section)
        guard let section = Section(rawValue: sections) else {
            return UITableViewCell()
        }
        switch section {
            case .requests:
                let friendRequestCell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath as IndexPath) as! FriendRequestCell;
                friendRequestCell.user = requests[indexPath.row]
                return friendRequestCell
            case .friends:
                let friendCell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath as IndexPath) as! FriendCell;
                friendCell.backgroundColor = UIColor.blue
                return friendCell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections = checkForRequests(section: section)
        guard let section = Section(rawValue: sections) else {
            return "..."
        }
        switch section {
            case .requests:
                return "Friend Requests"
            case .friends:
                return "Friends"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func checkForRequests(section : Int) -> Int {
        var sections = section
        if requests.isEmpty {
            sections += 1
        }
        return sections
    }
}

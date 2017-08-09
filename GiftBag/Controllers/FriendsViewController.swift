//
//  FriendsViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/8/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    var requests = [User]()
    var friends = [User]()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureWillAppear(animated)
        reloadTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToFriends(_ segue: UIStoryboardSegue) {
        print("Returned to Friends Screen!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDisplayFriend" {
                let destination = segue.destination as! DisplayFriendViewController
                guard let indexPath = tableView.indexPathForSelectedRow else {
                    return
                }
                destination.friend = friends[indexPath.row]
                print("To Friend Request Screen!")
            }
        }
    }
}

extension FriendsViewController {
    func configureView(){
        refreshControl.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.alwaysBounceVertical = true
    }
    
    func configureWillAppear(_ animated : Bool){
        refreshControl.endRefreshing()
        if tableView.contentOffset.y < 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                       at: .top,
                                       animated: animated)
        }
    }
    
    func reloadTable(){
        let dispatcher = DispatchGroup()
        dispatcher.enter()
        FriendService.showFriendRequests(for: User.current) { (users) in
            self.requests = users
            dispatcher.leave()
        }
        dispatcher.enter()
        UserService.showFriends(for: User.current) { (users) in
            self.friends = users
            dispatcher.leave()
        }
        dispatcher.notify(queue: .main) {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView.reloadData()
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
                let friendRequestCell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath as IndexPath) as! FriendRequestCell
                friendRequestCell.user = requests[indexPath.row]
                return friendRequestCell
            case .friends:
                let friendCell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath as IndexPath) as! FriendCell
                friendCell.user = friends[indexPath.row]
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
                let friendHeader = requests.count > 0 ? "Friend" : nil
                return friendHeader
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sections = checkForRequests(section: section)
        guard let section = Section(rawValue: sections) else {
            return 30
        }
        switch section {
        case .requests:
            return 30
        case .friends:
            let friendHeaderHeight = requests.count > 0 ? 30 : CGFloat.leastNormalMagnitude
            return friendHeaderHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let sections = checkForRequests(section: indexPath.section)
        guard let section = Section(rawValue: sections) else {
            return
        }
        switch section {
            case .requests:
                print("\(requests[indexPath.row].dictValue)")
                tableView.deselectRow(at: indexPath, animated: true)
                return
            case .friends:
                print("\(friends[indexPath.row].dictValue)")
                performSegue(withIdentifier: "toDisplayFriend", sender: self)
                tableView.deselectRow(at: indexPath, animated: true)
                return
        }

    }
    
    func checkForRequests(section : Int) -> Int {
        var sections = section
        if requests.isEmpty {
            sections += 1
        }
        return sections
    }
}

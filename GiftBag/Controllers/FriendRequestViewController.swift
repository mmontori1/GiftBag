//
//  FriendRequestViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/7/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController {

    var friend : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = friend else {
            return
        }
        print("User: \(user.username)")
        print("Name: \(user.firstName) \(user.lastName)")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//
//  FriendRequestViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/7/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView

class FriendRequestViewController: UIViewController {

    var friend : User?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendFriendRequestClicked(_ sender: UIButton) {
        guard let user = friend else {
            return
        }
        FriendService.sendFriendRequest(to: user) { (success) in
            if success {
                SCLAlertView().showSuccess("Success!", subTitle: "Friend Request has been sent to \(user.username)")
            }
        }
    }
}

extension FriendRequestViewController {
    func configureView(){
        usernameLabel.font = UIFont(name: Styles.mainFont, size: 30)
        nameLabel.font = UIFont(name: Styles.mainFont, size: 20)
        guard let user = friend else {
            return
        }
        usernameLabel.text = user.username
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        if let url = user.profileURL {
            let imageURL = URL(string: url)
            profileImageView.kf.setImage(with: imageURL)
        }
        else {
            profileImageView.image = UIImage(named: "defaultProfile")
        }
        profileImageView.circular(width: 1.0, color: UIColor.lightGray.cgColor)
    }
    
    func configureWillAppear(_ animated : Bool){
        guard let navigator = self.navigationController else {
            return
        }
        navigator.setNavigationBarHidden(false, animated: animated)
    }
}

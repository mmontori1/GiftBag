//
//  FriendRequestCell.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/8/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher

class FriendRequestCell: UITableViewCell {

    var user : User? = nil{
        didSet{
            setUp()
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(){
        profileImageView.circular(width: 1.0, color: UIColor.darkGray.cgColor)
    }
    
    func setUp(){
        guard let user = user else {
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
    }

    @IBAction func addFriendClicked(_ sender: UIButton) {
        guard let user = user else {
            return
        }
        FriendService.acceptFriendRequest(for: user) { (success) in
            if success {
                SCLAlertView().showSuccess("Success!", subTitle: "You are now friends with \(user.username)")
            }
        }
        print("Add a friend request!")
    }
    
    @IBAction func deleteFriendClicked(_ sender: UIButton) {
        print("Delete a friend request!")
    }
}

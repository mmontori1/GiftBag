//
//  FindFriendCell.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/7/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class FindFriendCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.circular(width: 1.0, color: UIColor.lightGray.cgColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

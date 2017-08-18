//
//  WishItemCell.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/1/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class WishItemCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var willPlanImage: UIImageView?
    @IBOutlet weak var willPlanLabel: UILabel?
    @IBOutlet weak var haveBoughtImage: UIImageView?
    
    var cellHeight : CGFloat = 0.0
    var item : WishItem? = nil{
        didSet{
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellHeight = nameLabel.bounds.height + imageView.bounds.height + 50
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setUp(){
        guard let item = item else {
            return
        }
        nameLabel.text = item.name
        nameLabel.font = UIFont(name: Styles.mainFont, size: 14)
        if let imageURL = item.imageURL {
            let imageURL = URL(string: imageURL)
            imageView.kf.setImage(with: imageURL)
        }
        else {
            imageView.image = UIImage(named: "comet")
        }
        setWillPlan()
        setHaveBought()
    }
    
    func setWillPlan(){
        guard let item = item,
            let willPlanImage = willPlanImage,
            let willPlanLabel = willPlanLabel else {
            return
        }
        
        willPlanImage.image = UIImage(named: "thinkEmpty")
        willPlanLabel.text = String(item.willPlan.count)
        if item.willPlan.count > 0 {
            willPlanImage.image = UIImage(named: "thinkExists")
        }
        if let exist = item.willPlan[User.current.uid],
            exist {
            willPlanImage.image = UIImage(named: "thinkFilled")
        }
    }
    
    func setHaveBought(){
        guard let item = item,
            let haveBoughtImage = haveBoughtImage else {
                return
        }
        haveBoughtImage.image = UIImage(named: "giveEmpty")
        if let boughtUserUID = item.haveBought{
            if User.current.uid == boughtUserUID {
                haveBoughtImage.image = UIImage(named: "giveFilled")
            }
            else {
                haveBoughtImage.image = UIImage(named: "giveExists")
            }
        }
    }
}

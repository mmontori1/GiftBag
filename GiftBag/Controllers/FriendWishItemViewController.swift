//
//  FriendWishItemViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/14/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//
import UIKit

class FriendWishItemViewController: UIViewController {
    
    var friend : User?
    var wishItem : WishItem?
    
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var willPlanButton: UIButton!
    @IBOutlet weak var willPlanLabel: UILabel!
    @IBOutlet weak var haveBoughtButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func haveBoughtClicked(_ sender: UIButton) {
        guard let user = friend,
            let item = wishItem else {
                return
        }
        haveBoughtButton.isEnabled = false
        WishService.setHaveBought(at: user, for: item) { (item) in
            if item != nil {
                self.wishItem = item
            }
            self.haveBoughtButton.isEnabled = true
            self.setHaveBought()
        }
    }
    @IBAction func willPlanClicked(_ sender: UIButton) {
        guard let user = friend,
            let item = wishItem else {
                return
        }
        willPlanButton.isEnabled = false
        WishService.setWillPlan(at: user, for: item) { (item) in
            if item != nil {
                self.wishItem = item
            }
            self.willPlanButton.isEnabled = true
            self.setWillPlan()
        }
    }
    
}

extension FriendWishItemViewController {
    func configureView(){
        setLabels()
        setWillPlan()
        setHaveBought()
    }
    
    func setLabels(){
        priceTitleLabel.font = UIFont(name: Styles.mainFont, size: 22)
        priceLabel.font = UIFont(name: Styles.mainFont, size: 22)
        willPlanLabel.font = UIFont(name: Styles.mainFont, size: 22)
        guard let item = wishItem else {
            print("wish item controller no item what")
            return
        }
        self.navigationItem.title = item.name
        priceLabel.text = String(format: "$%.2f", item.price)
    }
    
    func setWillPlan(){
        guard let item = wishItem,
            let willPlanButton = willPlanButton,
            let willPlanImage = willPlanButton.imageView,
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
        guard let item = wishItem,
            let haveBoughtButton = haveBoughtButton,
            let haveBoughtImage = haveBoughtButton.imageView else {
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

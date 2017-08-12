//
//  WishItemCell.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/1/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class WishItemCell: UICollectionViewCell {
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var willPlanButton: UIButton?
    @IBOutlet weak var willPlanLabel: UILabel?
    @IBOutlet weak var haveBoughtButton: UIButton?
    @IBOutlet weak var haveBoughtLabel: UILabel?
    
    var cellHeight : CGFloat = 0.0
    var item : WishItem? = nil{
        didSet{
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellHeight = nameTextField.bounds.height + imageView.bounds.height + 50
        self.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setUp(){
        guard let item = item else {
            return
        }
        nameTextField.text = item.name
    }
    @IBAction func willPlanClicked(_ sender: UIButton) {
        guard let willPlanButton = willPlanButton,
            let willPlanLabel = willPlanLabel,
            let text = willPlanLabel.text else {
                return
        }
        willPlanLabel.text = String(Int(text)! + 1)
        
    }
    
    @IBAction func haveBoughtClicked(_ sender: Any) {
        guard let willPlanButton = willPlanButton,
            let haveBoughtButton = haveBoughtButton else {
                return
        }
    }
}

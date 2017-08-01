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
    
    var cellHeight : CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellHeight = nameTextField.bounds.height + imageView.bounds.height + 50
        self.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
}

//
//  UIImageView+Utility.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/27/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func circular(width : CGFloat, color : CGColor){
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.borderWidth = width
        self.layer.borderColor = color
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}

//
//  UIButton+Utility.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/2/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func circular(){
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = frame.size.width / 2;
        self.clipsToBounds = true
    }
}

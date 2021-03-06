//
//  LoginHeaderViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/17/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class LoginHeaderViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyKeyboardDismisser()
        titleLabel.font = UIFont(name: Styles.mainFont, size: 30)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

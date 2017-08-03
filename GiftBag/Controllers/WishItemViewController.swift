//
//  WishItemViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/3/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class WishItemViewController: UIViewController {

    var wishItem : WishItem?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension WishItemViewController {
    func configureView(){
        setLabels()
    }
    
    func setLabels(){
        guard let item = wishItem else {
            print("wish item controller no item what")
            return
        }
        self.navigationItem.title = item.name
        if let price = item.price {
            priceLabel.text = String(format: "$%.2f", price)
        }
        else{
            priceLabel.text = "No Price"
        }
    }
}

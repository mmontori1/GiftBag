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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
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
        nameTextField.text = item.name
        if let price = item.price {
            priceTextField.text = String(format: "%.2f", price)
        }
        else{
            priceTextField.text = "No Price"
        }
    }
}

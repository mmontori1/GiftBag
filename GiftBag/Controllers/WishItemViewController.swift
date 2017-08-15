//
//  WishItemViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/3/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView

class WishItemViewController: UIViewController {
    
    let photoHelper = PhotoHelper()
    var wishItem : WishItem?
    var pictureCheck = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        photoHelper.completionHandler = { image in
            self.imageView.image = image
            self.pictureCheck = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changePictureClicked(_ sender: UIButton) {
        photoHelper.presentActionSheet(from: self)
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        guard let item = wishItem,
            let name = nameTextField.text,
            !name.isEmpty else {
                SCLAlertView().showError("No name", subTitle: "Fill a name for your wishlist item")
                return
        }
        
        var price : Double? = nil
        var image : UIImage? = nil
        
        if let priceText = priceTextField.text,
            priceText != "" {
            guard let value = Double(priceText),
                value >= 0 else {
                    SCLAlertView().showError("Invalid Price value", subTitle: "Fill with a valid price")
                    view.endEditing(true)
                    priceTextField.text = nil
                    return
            }
            price = value
        }
        
        if pictureCheck {
            image = self.imageView.image
        }
        WishService.edit(for: item, name: name, price: price, linkURL: nil, image: image) { (item) in
            self.wishItem = item
            self.performSegue(withIdentifier: "saveEdit", sender: self)
        }
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
        if let imageURL = item.imageURL {
            let imageURL = URL(string: imageURL)
            imageView.kf.setImage(with: imageURL)
        }
        else {
            imageView.image = UIImage(named: "comet")
        }
        if let price = item.price {
            priceTextField.text = String(format: "%.2f", price)
        }
        else{
            priceTextField.text = "No Price"
        }
    }
}

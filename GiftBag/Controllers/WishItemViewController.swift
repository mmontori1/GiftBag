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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
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
    
    @IBAction func deleteItemClicked(_ sender: Any) {
        guard let item = wishItem else {
            return
        }
        WishService.delete(for: item) { (success) in
            if success {
                self.performSegue(withIdentifier: "cancelEdit", sender: self)
            }
        }
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        guard let item = wishItem,
            let name = nameTextField.text,
            !name.isEmpty,
            let priceText = priceTextField.text,
            priceText != "",
            let value = Double(priceText),
            value >= 0
            else {
                SCLAlertView().showError("Error with name or price", subTitle: "Fix your inputs on name or price")
                view.endEditing(true)
                return
        }
        
        var image : UIImage? = nil
        
        if pictureCheck {
            image = self.imageView.image
        }
        WishService.edit(for: item, name: name, price: value, linkURL: nil, image: image) { (item) in
            self.wishItem = item
            self.performSegue(withIdentifier: "saveEdit", sender: self)
        }
    }
}

extension WishItemViewController {
    func configureView(){
        setLabels()
        nameLabel.font = UIFont(name: Styles.mainFont, size: 22)
        priceLabel.font = UIFont(name: Styles.mainFont, size: 22)
    }
    
    func setLabels(){
        guard let item = wishItem else {
            print("wish item controller no item what")
            return
        }
        nameTextField.text = item.name
        priceTextField.text = String(format: "%.2f", item.price)
        if let imageURL = item.imageURL {
            let imageURL = URL(string: imageURL)
            imageView.kf.setImage(with: imageURL)
        }
        else {
            imageView.image = UIImage(named: "comet")
        }
    }
}

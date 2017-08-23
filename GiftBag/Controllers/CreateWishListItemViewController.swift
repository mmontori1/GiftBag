//
//  CreateWishListItemViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/28/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher
import FirebaseStorage

class CreateWishListItemViewController: UIViewController {

    let photoHelper = PhotoHelper()
    var newItem : WishItem? = nil
    var pictureCheck = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        photoHelper.completionHandler = { image in
            self.itemImageView.image = image
            self.pictureCheck = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changePictureClicked(_ sender: UIButton) {
        photoHelper.presentActionSheet(from: self)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let name = nameTextField.text,
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
            image = self.itemImageView.image
        }
        
        newItem = WishItem(name: name, price: value, linkURL: nil, imageURL: nil)
        
        if let newItem = newItem  {
            WishService.create(for: newItem, image: image) { (item) in
                self.newItem = item
                print("performing segue!")
                self.performSegue(withIdentifier: "saveItem", sender: self)
                print("performed segue!")
            }
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Cancel button tapped")
            }
            else if identifier == "saveItem" {
                print("Save button tapped")
            }
        }
    }

}

extension CreateWishListItemViewController {
    func configureView() {
//        applyKeyboardDismisser()
        itemImageView.image = UIImage(named: "comet")
        titleLabel.font = UIFont(name: Styles.mainFont, size: 24)
        nameLabel.font = UIFont(name: Styles.mainFont, size: 17)
        priceLabel.font = UIFont(name: Styles.mainFont, size: 17)
    }
}

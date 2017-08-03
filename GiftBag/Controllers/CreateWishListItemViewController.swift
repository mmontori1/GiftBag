//
//  CreateWishListItemViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/28/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView

class CreateWishListItemViewController: UIViewController {

    var newItem : WishItem? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let name = nameTextField.text,
            !name.isEmpty else {
                SCLAlertView().showError("No name", subTitle: "Fill a name for your wishlist item")
                return
        }
        
        var linkURL : String? = nil
        var price : Double? = nil
        
        if let siteText = siteTextField.text,
            siteText != "" {
            linkURL = siteText
        }
        
        if let priceText = priceTextField.text,
            priceText != "" {
            guard let value = Double(priceText) else {
                SCLAlertView().showError("Invalid Price value", subTitle: "Fill with a correct double value")
                view.endEditing(true)
                priceTextField.text = nil
                return
            }
            price = value
        }
        
        newItem = WishItem(name: name, price: price, linkURL: linkURL, imageURL: nil)
        if let newItem = newItem  {
            WishService.create(data: newItem) { (item) in
                self.newItem = item
            }
        }
        else {
            print("no new item!!!")
        }
        print("performing segue!")
        performSegue(withIdentifier: "saveItem", sender: self)
        print("performed segue!")
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
        applyKeyboardDismisser()
    }
}

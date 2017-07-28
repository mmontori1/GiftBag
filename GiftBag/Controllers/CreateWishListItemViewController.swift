//
//  CreateWishListItemViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/28/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class CreateWishListItemViewController: UIViewController {

    var newItem : WishItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newItem = WishItem(name: "New Item", price: 0.00, linkURL: nil, imageURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
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
    
    /*
     guard let newItem = newItem else {
        print("no new item!!!")
        return
     }
    WishService.create(data: newItem) { (item) in
        guard let item = item else {
            print("no item!!!")
            return
        }
        print(item.dictValue)
     }
     */
 
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

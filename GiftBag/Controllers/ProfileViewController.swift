//
//  MainViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView

class ProfileViewController: UIViewController {
    
    var items = [WishItem]() {
        didSet {
            items.sort(by: { $0.timestamp.compare($1.timestamp as Date) == .orderedDescending })
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.wishlist(for: User.current) { (savedItems) in
            self.items = savedItems
            let values = self.items.map {$0.dictValue}
            print(values)
        }
        usernameLabel.text = User.current.username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toSettings" {
                print("To Settings Screen!")
            }
            else if identifier == "toCreateItem" {
                print("To Create Item")
            }
        }
    }
    
    @IBAction func addItemClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateItem", sender: self)
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        usernameLabel.text = User.current.username
        if let identifier = segue.identifier {
            if identifier == "saveItem" {
                let createWishListController = segue.source as! CreateWishListItemViewController
                guard let newItem = createWishListController.newItem else {
                    SCLAlertView().genericError()
                    return
                }
                items.append(newItem)
                SCLAlertView().showSuccess("Success!", subTitle: "You've created a new wish list item")
            }
        }
        print("Returned to Main Screen!")
    }
}

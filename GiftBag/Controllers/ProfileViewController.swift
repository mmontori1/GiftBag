//
//  MainViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "\(User.current.firstName) \(User.current.lastName)"
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
        }
    }
    
    @IBAction func addItemClicked(_ sender: UIBarButtonItem) {
        let timeInterval = Date().timeIntervalSince1970
        let userDict = ["uid" : User.current.uid,
                        "username" : User.current.username,
                        "firstName" : User.current.firstName,
                        "lastName" : User.current.lastName]
        let value : [String : Any] = ["poster" : userDict,
                                      "name" : "New Item",
                                      "timestamp" : timeInterval
//                                          ,
//                                          "price" : nil,
//                                          "linkURL" : nil,
//                                          "imageURL" : nil
                                     ]
        WishService.create(data: value) { (item) in
            guard let item = item else {
                print("no item!!!")
                return
            }
            print(item.dictValue)
        }
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        nameLabel.text = "\(User.current.firstName) \(User.current.lastName)"
        usernameLabel.text = User.current.username
        print("Returned to Main Screen!")
    }
}

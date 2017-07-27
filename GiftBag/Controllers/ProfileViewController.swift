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
    
    @IBAction func settingsClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        print("Returned to Main Screen!")
    }
}

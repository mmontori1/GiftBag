//
//  EditProfileViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/27/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func saveClicked(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text
            else { return }
        
        if username == User.current.username &&
            firstName == User.current.firstName &&
            lastName == User.current.lastName {
            makeSimpleAlert(title: "No changes made", message: "Make some changes first...")
            return
        }
        
        UserService.edit(username: username, firstName: firstName, lastName: lastName) { (user) in
            defer {
                self.makeSimpleAlert(title: "Success!", message: nil)
            }
            
            guard let user = user
                else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
        }
    }
}

extension EditProfileViewController {
    func configureView() {
        applyKeyboardDismisser()
        
        profileImageView.circular(width: 1.0, color: UIColor.darkGray.cgColor)
        firstNameTextField.text = User.current.firstName
        firstNameTextField.placeholder = "First Name"
        
        lastNameTextField.text = User.current.lastName
        lastNameTextField.placeholder = "Last Name"
        
        usernameTextField.text = User.current.username
        usernameTextField.placeholder = "Username"
    }
    
    func makeSimpleAlert(title : String?, message : String?){
        let alert = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  UserInfoViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/16/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher
import FirebaseAuth
import FirebaseStorage

class UserInfoViewController: UIViewController {

    let photoHelper = PhotoHelper()
    var pictureCheck = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoHelper.completionHandler = { image in
            self.profileImageView.image = image
            self.pictureCheck = true
        }
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text
            else { return }
        
        if (username.isEmpty ||
            firstName.isEmpty ||
            lastName.isEmpty){
            SCLAlertView().showWarning("Fill out user info.", subTitle: "Please fill out username, first name, and last name")
            return
        }
        
        var image : UIImage? = nil
        if pictureCheck {
            image = self.profileImageView.image
        }
        
        UserService.create(firUser, username: username, firstName: firstName, lastName: lastName, image: image) { (user) in
            
            guard let user = user else {
                SCLAlertView().genericError()
                return
            }
            
            User.setCurrent(user, writeToUserDefaults: true)
            SCLAlertView().showSuccess("Success!", subTitle: "Your changes have been saved.")
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    @IBAction func editImageClicked(_ sender: UIButton) {
        photoHelper.presentActionSheet(from: self)
    }
}

extension UserInfoViewController {
    func configureView() {
//        applyKeyboardDismisser()
//        dismissKeyboard()
        
        profileImageView.circular(width: 1.0, color: UIColor.darkGray.cgColor)
        editImageButton.circular()
        profileImageView.image = UIImage(named: "defaultProfile")

        usernameTextField.placeholder = "Username"
        firstNameTextField.placeholder = "First Name"
        lastNameTextField.placeholder = "Last Name"
        
        titleLabel.font = UIFont(name: Styles.mainFont, size: 32)
        usernameLabel.font = UIFont(name: Styles.mainFont, size: 14)
        firstNameLabel.font = UIFont(name: Styles.mainFont, size: 14)
        lastNameLabel.font = UIFont(name: Styles.mainFont, size: 14)
    }
}

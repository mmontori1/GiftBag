//
//  EditProfileViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/27/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher
import FirebaseStorage

class EditProfileViewController: UIViewController {

    let photoHelper = PhotoHelper()
    var pictureCheck = false
    
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
            self.profileImageView.kf.base.image = image
            self.pictureCheck = true
        }
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
            lastName == User.current.lastName &&
            !pictureCheck {
            SCLAlertView().showWarning("No changes made.", subTitle: "Make changes to your profile first.")
            return
        }
        
        var image : UIImage? = nil
        if pictureCheck {
            image = self.profileImageView.kf.base.image
        }
        
        UserService.edit(username: username, firstName: firstName, lastName: lastName, image: image) { (user) in
            
            guard let user = user else {
                SCLAlertView().genericError()
                return
            }
            
            User.setCurrent(user, writeToUserDefaults: true)
            SCLAlertView().showSuccess("Success!", subTitle: "Your changes have been saved.")
        }
    }
    @IBAction func editImageClicked(_ sender: UIButton) {
        photoHelper.presentActionSheet(from: self)
    }
}

extension EditProfileViewController {
    func configureView() {
//        applyKeyboardDismisser()
        
        profileImageView.circular(width: 1.0, color: UIColor.darkGray.cgColor)
        editImageButton.circular()
        
        if let url = User.current.profileURL {
            let imageURL = URL(string: url)
            profileImageView.kf.setImage(with: imageURL)
        }
        else {
            profileImageView.kf.base.image = UIImage(named: "defaultProfile")
        }
        
        firstNameLabel.font = UIFont(name: Styles.mainFont, size: 17)
        firstNameTextField.text = User.current.firstName
        firstNameTextField.placeholder = "First Name"
        
        lastNameLabel.font = UIFont(name: Styles.mainFont, size: 17)
        lastNameTextField.text = User.current.lastName
        lastNameTextField.placeholder = "Last Name"
        
        usernameLabel.font = UIFont(name: Styles.mainFont, size: 17)
        usernameTextField.text = User.current.username
        usernameTextField.placeholder = "Username"
    }
}

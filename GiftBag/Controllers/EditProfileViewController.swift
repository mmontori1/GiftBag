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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = User.current.profileURL {
            let imageURL = URL(string: url)
            profileImageView.kf.setImage(with: imageURL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoHelper.completionHandler = { image in
            self.profileImageView.image = image
            let ref = Storage.storage().reference().child("images/profile/\(User.current.uid).jpg")
            StorageService.uploadImage(image, at: ref, completion: { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                
                let urlString = downloadURL.absoluteString
                let imageURL = URL(string: urlString)
                self.profileImageView.kf.setImage(with: imageURL)
                UserService.editProfileImage(url: urlString, completion: { (user) in
                    if let user = user {
                        User.setCurrent(user, writeToUserDefaults: true)
                    }
                    SCLAlertView().showSuccess("Success!", subTitle: "Your picture has been updated.")
                })
            })
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
            lastName == User.current.lastName {
            SCLAlertView().showWarning("No changes made.", subTitle: "Make changes to your profile first.")
            return
        }
        
        UserService.edit(username: username, firstName: firstName, lastName: lastName) { (user) in

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
        applyKeyboardDismisser()
        
        profileImageView.circular(width: 1.0, color: UIColor.darkGray.cgColor)
        editImageButton.circular()
        firstNameTextField.text = User.current.firstName
        firstNameTextField.placeholder = "First Name"
        
        lastNameTextField.text = User.current.lastName
        lastNameTextField.placeholder = "Last Name"
        
        usernameTextField.text = User.current.username
        usernameTextField.placeholder = "Username"
    }
}

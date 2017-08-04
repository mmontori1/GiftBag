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
    var isPhotoChanged = false
    
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
            self.isPhotoChanged = true
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
            !isPhotoChanged {
            SCLAlertView().showWarning("No changes made.", subTitle: "Make changes to your profile first.")
            return
        }
        
        let dispatcher = DispatchGroup()
        var changedUser : User? = nil
        var newUsername : String = User.current.username
        var newFirstName : String = User.current.firstName
        var newLastName : String = User.current.lastName
        var newProfileURL : String? = nil
        if isPhotoChanged {
            guard let image = profileImageView.image else {
                return
            }
            let ref = Storage.storage().reference().child("images/profile/\(User.current.uid).jpg")
            dispatcher.enter()
            StorageService.uploadImage(image, at: ref, completion: { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                
                let urlString = downloadURL.absoluteString
                let imageURL = URL(string: urlString)
                self.profileImageView.kf.setImage(with: imageURL)
                UserService.editProfileImage(url: urlString, completion: { (user) in
                    newProfileURL = urlString
                    dispatcher.leave()
                })
            })
        }
        
        dispatcher.enter()
        UserService.edit(username: username, firstName: firstName, lastName: lastName) { (user) in
            guard let user = user else {
                SCLAlertView().genericError()
                return
            }
            newUsername = user.username
            newFirstName = user.firstName
            newLastName = user.lastName
            dispatcher.leave()
        }
        
        dispatcher.notify(queue: .main) {
            changedUser = User(uid: User.current.uid, username: newUsername, firstName: newFirstName, lastName: newLastName, profileURL: newProfileURL)
            if let user = changedUser {
                User.setCurrent(user, writeToUserDefaults: true)
                SCLAlertView().showSuccess("Success!", subTitle: "Your changes have been saved.")
            }
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

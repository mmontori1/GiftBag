//
//  CreateUserViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateUserViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Back to Login screen!")
            }
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirm = confirmTextField.text,
            password == confirm
//            !username.isEmpty,
//            !firstName.isEmpty,
//            !lastName.isEmpty
            else {
                print("Required fields are not all filled!")
                return
            }
        
        AuthService.createUser(controller: self, email: email, password: password) { (authUser) in
            guard authUser != nil else {
                return
            }
            
//            UserService.create(firUser, username: username, firstName: firstName, lastName: lastName) { (user) in
//                guard let user = user else {
//                    return
//                }
//                
//                User.setCurrent(user, writeToUserDefaults: true)
            
                let initialViewController = UIStoryboard.initialViewController(for: .info)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
//            }
        }
    }
}

extension CreateUserViewController{
    func configureView(){
        signUpButton.layer.cornerRadius = 10
    }
}

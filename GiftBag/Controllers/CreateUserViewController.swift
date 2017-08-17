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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmLabel: UILabel!
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
            else {
                print("Required fields are not all filled!")
                return
            }
        
        AuthService.createUser(controller: self, email: email, password: password) { (authUser) in
            guard authUser != nil else {
                return
            }
            
            let initialViewController = UIStoryboard.initialViewController(for: .info)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}

extension CreateUserViewController{
    func configureView(){
        signUpButton.layer.cornerRadius = 10
        let goodTime = "GoodTimesRg-Regular"
        let helvetica = "Helvetica-Semibold"
        signUpButton.layer.cornerRadius = 10
        titleLabel.font = UIFont(name: goodTime, size: 30)
//        subtitleLabel.font = UIFont(name: helvetica, size: 12)
        createAccountLabel.font = UIFont(name: goodTime, size: 20)
        emailLabel.font = UIFont(name: helvetica, size: 14)
        passwordLabel.font = UIFont(name: helvetica, size: 14)
        confirmLabel.font = UIFont(name: helvetica, size: 14)
        signUpButton.titleLabel?.font = UIFont(name: goodTime, size: 15)
    }
}

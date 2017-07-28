//
//  ForgotPasswordViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/25/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetPasswordClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty
            else { return }
        AuthService.passwordReset(email: email, success: { (success) in
            if success {
                SCLAlertView().showSuccess("Success!", subTitle: "Email sent.")
            }
            else {
                SCLAlertView().genericError()
            }
        })
    }
}

extension ForgotPasswordViewController{
    func configureView(){
        applyKeyboardPush()
        applyKeyboardDismisser()
    }
}

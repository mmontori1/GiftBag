//
//  SettingsViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/26/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCLAlertView

class SettingsViewController: UITableViewController {
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authHandle = AuthService.authListener(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toEditProfile" {
                print("To Edit Profile Screen!")
            }
        }
    }
    
    deinit {
        AuthService.removeAuthListener(authHandle: authHandle)
    }
    
    @IBAction func unwindToSettings(_ segue: UIStoryboardSegue) {
        print("Returned to Settings Screen!")
    }
}

extension SettingsViewController {
    enum Section : Int {
        case accountSettings = 0
    }
    
    enum AccountSettings : Int {
        case editProfile = 0, resetPassword, logOut, deleteAccount
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section),
            let row = AccountSettings(rawValue: indexPath.row) else {
                return
        }
        switch section {
            case .accountSettings:
                switch row {
                    case .editProfile:
                        performSegue(withIdentifier: "toEditProfile", sender: self)
                    case .resetPassword:
                        guard let auth = Auth.auth().currentUser,
                            let email = auth.email else {
                                SCLAlertView().genericError()
                                return
                        }
                        AuthService.passwordReset(email: email, success: { (success) in
                            if success {
                                SCLAlertView().showSuccess("Success!", subTitle: "Email sent.")
                            }
                            else {
                                SCLAlertView().genericError()
                            }
                        })
                    case .logOut:
                        AuthService.presentLogOut(viewController: self)
                    case .deleteAccount:
                        AuthService.presentDelete(viewController: self)
                }
        }
    }
}

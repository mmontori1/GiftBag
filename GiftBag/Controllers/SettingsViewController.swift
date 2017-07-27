//
//  SettingsViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/26/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UITableViewController {
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authHandle = AuthService.authListener(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        AuthService.removeAuthListener(authHandle: authHandle)
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        AuthService.presentLogOut(viewController: self)
    }
    
    @IBAction func deleteAccountClicked(_ sender: Any) {
        AuthService.presentDelete(viewController: self)
    }
}

extension SettingsViewController {
    enum Section : Int {
        case accountSettings = 0
    }
    
    enum AccountSettings : Int {
        case editProfile = 0, logOut, deleteAccount
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
                        break
                    case .logOut:
                        AuthService.presentLogOut(viewController: self)
                    case .deleteAccount:
                        AuthService.presentDelete(viewController: self)
                }
        }
    }
}

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

extension SettingsViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
            case 0:
                switch indexPath.row{
                    case 0:
                        break
                    case 1:
                        AuthService.presentLogOut(viewController: self)
                    case 2:
                        AuthService.presentDelete(viewController: self)
                    default:
                        return
                }
            default:
                return
        }
    }
}

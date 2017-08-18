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
    
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var resetPassLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authHandle = AuthService.authListener(viewController: self)
        editLabel.font = UIFont(name: Styles.mainFont, size: 17)
        resetPassLabel.font = UIFont(name: Styles.mainFont, size: 17)
        logOutLabel.font = UIFont(name: Styles.mainFont, size: 17)
        deleteLabel.font = UIFont(name: Styles.mainFont, size: 17)
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
                        AuthService.presentPasswordReset(controller: self)
                    case .logOut:
                        AuthService.presentLogOut(viewController: self)
                    case .deleteAccount:
                        AuthService.presentDelete(viewController: self)
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

//
//  UserService.swift
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import SCLAlertView
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, username: String, firstName: String, lastName: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username,
                         "firstName": firstName,
                         "lastName": lastName]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        let usernameRef = Database.database().reference().child("usernames")
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
        usernameRef.setValue([username : true])
    }
    
    static func edit(username: String, firstName: String, lastName: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username,
                         "firstName": firstName,
                         "lastName": lastName]
        
        
        checkForUniqueUsername(for: username) { (success) in
            if success {
                let ref = Database.database().reference().child("users").child(User.current.uid)
                let usernameRef = Database.database().reference().child("usernames")

                usernameRef.setValue([User.current.username : NSNull()])
            
                ref.updateChildValues(userAttrs) { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        return completion(nil)
                    }
                
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        let user = User(snapshot: snapshot)
                    completion(user)
                    })
                }
        
                usernameRef.setValue([username : true])
            }
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func observeProfile(for user: User, completion: @escaping (DatabaseReference, User?) -> Void) -> DatabaseHandle {
        let userRef = Database.database().reference().child("users").child(user.uid)
        return userRef.observe(.value, with: { snapshot in
            guard let user = User(snapshot: snapshot) else {
                return completion(userRef, nil)
            }
            completion(userRef, user)
        })
    }
    
    static func deleteUser(for user: User, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        var updatedData : [String : Any] = [:]
        updatedData["users/\(user.uid)"] = NSNull()
        updatedData["usernames/\(user.username)"] = NSNull()
        updatedData["wishItems/\(user.uid)"] = NSNull()
        ref.updateChildValues(updatedData) { (error, ref) -> Void in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return success(false)
            }
            success(true)
        }
    }
    
    static func wishlist(for user: User, completion: @escaping ([WishItem]) -> Void) {
        let ref = Database.database().reference().child("wishItems").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let items: [WishItem] =
                snapshot.flatMap {
                    guard let item = WishItem(snapshot: $0)
                        else { return nil }
                    return item
                }
            
            completion(items)
        })
    }
    
    static func editProfileImage(url: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["profileURL": url]
        
        let ref = Database.database().reference().child("users").child(User.current.uid)
        ref.updateChildValues(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func checkForUniqueUsername(for name: String, success: @escaping (Bool) -> Void) {
        let usernameRef = Database.database().reference().child("usernames")
        usernameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : Any],
            let newName = dict[name] as? Bool{
                SCLAlertView().showError("Pick a unique username", subTitle: "Username \(name) already exists")
                return success(false)
            }
            success(true)
        })
    }
}

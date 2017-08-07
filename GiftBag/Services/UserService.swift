//
//  UserService.swift
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, username: String, firstName: String, lastName: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username,
                         "firstName": firstName,
                         "lastName": lastName]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
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
    }
    
    static func edit(username: String, firstName: String, lastName: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username,
                         "firstName": firstName,
                         "lastName": lastName]
        
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
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func showAllUsers(completion: @escaping([User]) -> Void){
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let users: [User] =
                snapshot.flatMap {
                    guard let item = User(snapshot: $0)
                        else { return nil }
                    return item
            }
            
            completion(users)
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
    
    static func deleteUser(forUID uid: String, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        var updatedData : [String : Any] = [:]
        updatedData["users/\(uid)"] = NSNull()
        updatedData["wishItems/\(uid)"] = NSNull()
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
}

//
//  FriendService.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/7/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FriendService {
    static func sendFriendRequest(to friendUser: User, success: @escaping (Bool) -> Void){
        let ref = Database.database().reference().child("friendRequests").child(friendUser.uid).child(User.current.uid)
        let userData = User.current.dictValue
        ref.setValue(userData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            success(true)
        }

    }
    
    
    static func showFriendRequests(for user: User, completion: @escaping ([User]) -> Void){
        let ref = Database.database().reference().child("friendRequests").child(user.uid)
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
    
    static func acceptFriendRequest(for user: User, success: @escaping (Bool) -> Void){
        let currentUser = User.current
        let ref = Database.database().reference().child("friends")
        let updateData = [currentUser.uid : user.dictValue,
                          user.uid : currentUser.dictValue]
        
        ref.updateChildValues(updateData){ (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            deleteFriendRequest(for: user, success: { (successful) in
                if !successful {
                    return success(false)
                }
                success(true)
            })
        }
    }

    static func deleteFriendRequest(for user: User, success: @escaping (Bool) -> Void){
        let currentUser = User.current
        let ref = Database.database().reference().child("friendRequests").child(currentUser.uid)
        
        let removalData = [user.uid : NSNull()]
        ref.setValue(removalData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            success(true)
        }
    }
}

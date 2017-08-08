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
        let ref = Database.database().reference().child("friendRequests").child(friendUser.uid)

        let userData = [User.current.uid : true]
        ref.updateChildValues(userData) { (error, ref) in
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
            var users = [User]()
            var userUIDs = [String]()
            for value in snapshot {
                userUIDs.append(value.key)
            }
            let dispatcher = DispatchGroup()
            for uid in userUIDs {
                dispatcher.enter()
                UserService.show(forUID: uid, completion: { (user) in
                    guard let user = user else {
                        dispatcher.leave()
                        return
                    }
                    users.append(user)
                    dispatcher.leave()
                })
            }
            dispatcher.notify(queue: .main) {
                completion(users)
            }
        })
    }
    
    static func acceptFriendRequest(for user: User, success: @escaping (Bool) -> Void){
        let currentUser = User.current
        let rootRef = Database.database().reference().child("friends")
        let userRef = rootRef.child(currentUser.uid)
        let friendRef = rootRef.child(user.uid)
        let userData = [user.uid : true]
        let friendData = [currentUser.uid : true]
        let dispatcher = DispatchGroup()
        var check = true
        
        dispatcher.enter()
        userRef.updateChildValues(userData){ (error, userRef) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                check = false
            }
            dispatcher.leave()
        }
        
        dispatcher.enter()
        friendRef.updateChildValues(friendData){ (error, friendRef) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                check = false
            }
            dispatcher.leave()
        }
        
        dispatcher.enter()
        deleteFriendRequest(for: user, success: { (successful) in
            if !successful {
                check = false
            }
            dispatcher.leave()
        })
        
        dispatcher.notify(queue: .main) {
            success(check)
        }
    }

    static func deleteFriendRequest(for user: User, success: @escaping (Bool) -> Void){
        let currentUser = User.current
        let ref = Database.database().reference().child("friendRequests").child(currentUser.uid)
        
        let removalData = [user.uid : NSNull()]
        ref.updateChildValues(removalData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            success(true)
        }
    }
}

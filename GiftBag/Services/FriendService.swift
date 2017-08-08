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
        let ref = Database.database().reference().child("friends")
        let updateData = [currentUser.uid : [user.uid : true],
                          user.uid : [currentUser.uid : true]]
        
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
        ref.updateChildValues(removalData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            success(true)
        }
    }
}

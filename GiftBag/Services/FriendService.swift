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
        userData = User.current.dictValue
        let ref = Database.database().reference().child("friendRequests").child(friendUser.uid)
        ref.setValue(userData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(false)
            }
            
            completion(true)
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
    
    static func acceptFriendRequest(completion: @escaping (User?) -> Void){
        
    }

    static func deleteFriendRequest(completion: @escaping (User?) -> Void){
        
    }
}

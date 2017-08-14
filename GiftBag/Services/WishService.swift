//
//  WishService.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/28/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

struct WishService {
    static func create(data item : WishItem, completion: @escaping (WishItem?) -> Void) {
        let ref = Database.database().reference().child("wishItems").child(User.current.uid).childByAutoId()
        ref.setValue(item.dictValue) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            completion(item)
        }
    }
    
    static func show(for user : User, with key : String, completion: @escaping (WishItem?) -> Void){
        let ref = Database.database().reference().child("wishItems").child(user.uid).child(key)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let item = WishItem(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(item)
        })
    }
    
    static func setWillPlan(at user : User, for item : WishItem, completion: @escaping (WishItem?) -> Void){
        let currentUID = User.current.uid
        guard let key = item.key else {
            return
        }
        let ref = Database.database().reference().child("wishItems").child(user.uid).child(key).child("willPlan")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(currentUID){
                willPlanOff(ref: ref, success: { (success) in
                    if success {
                        show(for: user, with: key, completion: { (item) in
                            return completion(item)
                        })
                    }
                    else {
                        completion(nil)
                    }
                })
            }
            else {
                willPlanOn(ref: ref, success: { (success) in
                    if success {
                        show(for: user, with: key, completion: { (item) in
                            return completion(item)
                        })
                    }
                    else {
                        completion(nil)
                    }
                })
            }
        })
    }
    
    private static func willPlanOn(ref : DatabaseReference, success : @escaping (Bool) -> Void){
        let currentUID = User.current.uid
        let data = [currentUID : true]
        ref.updateChildValues(data) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                success(false)
            }
            success(true)
        }
    }
    
    private static func willPlanOff(ref : DatabaseReference, success : @escaping (Bool) -> Void){
        let currentUID = User.current.uid
        let data = [currentUID : NSNull()]
        ref.updateChildValues(data) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                success(false)
            }
            success(true)
        }
    }
    
    static func setHaveBought(at user : User, for item : WishItem, completion: @escaping (WishItem?) -> Void){
        let currentUID = User.current.uid
        guard let key = item.key else {
            return
        }
        let ref = Database.database().reference().child("wishItems").child(user.uid).child(key)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("haveBought"){
                guard let dict = snapshot.value as? [String : Any],
                    let uid = dict["haveBought"] as? String else {
                        return completion(item)
                }
                if uid == currentUID {
                    haveBoughtOff(ref: ref, success: { (success) in
                        if success {
                            show(for: user, with: key, completion: { (item) in
                                return completion(item)
                            })
                        }
                        else {
                            return completion(nil)
                        }
                    })
                }
                else{
                    return completion(item)
                }
            }
            else{
                haveBoughtOn(ref: ref, success: { (success) in
                    if success {
                        show(for: user, with: key, completion: { (item) in
                            return completion(item)
                        })
                    }
                    else {
                        return completion(nil)
                    }
                })
            }
        })
    }
    
    private static func haveBoughtOn(ref : DatabaseReference, success : @escaping (Bool) -> Void){
        let currentUID = User.current.uid
        let data = ["haveBought" : currentUID]
        ref.updateChildValues(data) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                success(false)
            }
            success(true)
        }
    }
    
    private static func haveBoughtOff(ref : DatabaseReference, success : @escaping (Bool) -> Void){
        let data = ["haveBought" : NSNull()]
        ref.updateChildValues(data) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                success(false)
            }
            success(true)
        }
    }
}

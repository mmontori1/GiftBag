//
//  WishService.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/28/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot
import FirebaseStorage

struct WishService {
    static func create(for item : WishItem, image : UIImage?, completion: @escaping (WishItem?) -> Void) {
        let ref = Database.database().reference().child("wishItems").child(User.current.uid).childByAutoId()
        if let image = image {
            let storageRef = Storage.storage().reference().child("images/items/\(User.current.uid)/\(ref.key).jpg")
            StorageService.uploadImage(image, at: storageRef, completion: { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                item.imageURL = downloadURL.absoluteString
                make(for: item, at: ref, completion: { (item) in
                    completion(item)
                })
            })
        }
        else {
            make(for: item, at: ref, completion: { (item) in
                completion(item)
            })
        }
    }
    
    private static func make(for item : WishItem, at ref : DatabaseReference, completion: @escaping (WishItem?) -> Void){
        ref.setValue(item.dictValue) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            show(for: User.current, with: ref.key, completion: { (item) in
                completion(item)
            })
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
    
    static func edit(for item : WishItem, name : String, price : Double, linkURL: String?, image: UIImage?, completion: @escaping (WishItem?) -> Void) {
        guard let key = item.key else {
            return completion(nil)
        }
        var itemData = ["name" : name,
                        "price" : price] as [String : Any]
        if let linkURL = linkURL {
            itemData["linkURL"] = linkURL
        }
        if let image = image {
            let storageRef = Storage.storage().reference().child("images/items/\(User.current.uid)/\(key).jpg")
            StorageService.uploadImage(image, at: storageRef, completion: { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                itemData["imageURL"] = downloadURL.absoluteString
                update(for: item, key: key, with: itemData, completion: { (item) in
                    completion(item)
                })
            })
        }
        else {
            update(for: item, key: key, with: itemData, completion: { (item) in
                completion(item)
            })
        }
    }
    
    private static func update(for item: WishItem, key : String, with data : [String : Any], completion: @escaping (WishItem?) -> Void){
        let ref = Database.database().reference().child("wishItems").child(User.current.uid).child(key)
        ref.updateChildValues(data) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let item = WishItem(snapshot: snapshot)
                completion(item)
            })
        }
    }
    
    static func delete(for item : WishItem, success: @escaping (Bool) -> Void){
        guard let key = item.key else {
            return
        }
        var check = true
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("wishItems").child(currentUID)
        let storageRef = Storage.storage().reference().child("images/items/\(User.current.uid)/\(key).jpg")
        let updatedData = [key : NSNull()]
        let dispatcher = DispatchGroup()
        
        if let _ = item.imageURL {
            dispatcher.enter()
            StorageService.deleteImage(at: storageRef) { (result) in
                if !result {
                    check = false
                }
                dispatcher.leave()
            }
        }
        
        dispatcher.enter()
        ref.updateChildValues(updatedData) { (error, ref) -> Void in
            if let error = error {
                print("error : \(error.localizedDescription)")
                check = false
            }
            dispatcher.leave()
        }
        
        dispatcher.notify(queue: .main) {
            success(check)
        }
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

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
    
    /*
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (WishItem?) -> Void) {
        let ref = Database.database().reference().child("wishItems").child(posterUID).child(postKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let item = WishItem(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(item)
        })
    }
    */
}

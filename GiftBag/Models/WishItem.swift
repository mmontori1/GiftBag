//
//  WishItem.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/28/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class WishItem {
     
    var key: String?
    let poster: User
    let name : String
    let timestamp : Date
    var price : Double?
    var linkURL : String?
    var imageURL : String?
    var dictValue: [String : Any] {
        let userDict = ["uid" : poster.uid,
                        "username" : poster.username,
                        "firstName" : poster.firstName,
                        "lastName" : poster.lastName]
        var value : [String : Any] = ["poster" : userDict,
                                      "name" : name,
                                      "timestamp" : timestamp.timeIntervalSince1970]
        
        if let price = price {
            value["price"] = price
        }
        if let linkURL = linkURL {
            value["linkURL"] = linkURL
        }
        if let imageURL = imageURL {
            value["imageURL"] = imageURL
        }

        return value
    }
    
    init(name : String, price : Double? = nil, linkURL : String? = nil, imageURL : String? = nil) {
        self.poster = User.current
        self.name = name
        self.timestamp = Date()
        self.price = price
        self.linkURL = linkURL
        self.imageURL = imageURL
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let poster = dict["poster"] as? [String : Any],
            let uid = poster["uid"] as? String,
            let username = poster["username"] as? String,
            let firstName = poster["firstName"] as? String,
            let lastName = poster["lastName"] as? String,
            let name = dict["name"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval
            else { return nil }
        self.key = snapshot.key
        self.poster = User(uid: uid, username: username, firstName: firstName, lastName: lastName)
        self.name = name
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        
        if let price = dict["price"] as? Double {
            self.price = price
        }
        if let linkURL = dict["linkURL"] as? String {
            self.linkURL = linkURL
        }
        if let imageURL = dict["imageURL"] as? String {
            self.imageURL = imageURL
        }
    }
    
}

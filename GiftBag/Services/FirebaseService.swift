//
//  FirebaseService.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/27/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FirebaseService {
    static func checkConnection(success : @escaping (Bool) -> Void){
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observeSingleEvent(of: .value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                return success(true)
            }
            else {
                return success(false)
            }
        })
    }
}

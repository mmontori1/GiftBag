//
//  StorageService.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/7/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseStorage

struct StorageService {
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {

        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)!!")
                return completion(nil)
            }
            
            completion(metadata?.downloadURL())
        })
    }
    
    static func deleteImage(at ref : StorageReference, success: @escaping (Bool) -> Void){
        ref.delete { (error) in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return success(false)
            }
            success(true)
        }
    }
}

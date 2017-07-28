//
//  CustomSegues.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/28/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import UIKit

class SegueFromRight: UIStoryboardSegue {
    override func perform() {
        
        //set the ViewControllers for the animation
        let sourceView = self.source.view as UIView!
        let destinationView = self.destination.view as UIView!
        
        let window = UIApplication.shared.delegate?.window!
        //set the destination View center
        destinationView?.center = CGPoint(x: (sourceView?.center.x)! - (destinationView?.center.x)!, y: (sourceView?.center.y)!)
        
        // the Views must be in the Window hierarchy, so insert as a subview the destionation above the source
        window?.insertSubview(destinationView!, aboveSubview: sourceView!)
        
        //create UIAnimation- change the views's position when present it
        UIView.animate(withDuration: 0.4,
                       animations: {
                        destinationView?.center = CGPoint(x: (sourceView?.center.x)!, y: (sourceView?.center.y)!)
                        sourceView?.center = CGPoint(x: 0 + 2 * (destinationView?.center.x)!, y: (sourceView?.center.y)!)
        }, completion: {
            (value: Bool) in
            self.source.navigationController?.pushViewController(self.destination, animated: false)
            
            
        })
    }
}

class UnwindFromRight: UIStoryboardSegue {
    override func perform() {
        //set the ViewControllers for the animation
        let sourceView = self.source.view as UIView!
        let destinationView = self.destination.view as UIView!
        let window = UIApplication.shared.delegate?.window!
        
        window?.insertSubview(destinationView!, belowSubview: sourceView!)
        
        
        //2. y cordinate change
        destinationView?.center = CGPoint(x: (sourceView?.center.x)! + (destinationView?.center.x)!, y: (sourceView?.center.y)!)
        
        
        //3. create UIAnimation- change the views's position when present it
        UIView.animate(withDuration: 0.4,
                       animations: {
                        destinationView?.center = CGPoint(x: (sourceView?.center.x)!, y: (sourceView?.center.y)!)
                        sourceView?.center = CGPoint(x: 0 - 2 * (destinationView?.center.x)!, y: (sourceView?.center.y)!)
        }, completion: {
            (value: Bool) in
            destinationView?.removeFromSuperview()
            if let navController = self.destination.navigationController {
                navController.popToViewController(self.destination, animated: false)
            }
            
            
        })
    }
}

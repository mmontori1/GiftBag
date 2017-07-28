//
//  SCLAlertView+Utility.swift
//  GiftBag
//
//  Created by Mariano Montori on 7/27/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import SCLAlertView

extension SCLAlertView {
    func genericError() {
        SCLAlertView().showError("Oops!", subTitle: "Something went wrong.")
    }
}

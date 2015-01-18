//
//  _Model.swift
//  pastcast
//
//  Created by JP Gary on 7/25/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

import UIKit
import CoreLocation


// Global Ref initiated only once.
var pastCastModel = PastCastModel()

class PastCastModel {
    // add variables here:
    // let
    // var
    
    // default is false
    var isCelsius   = false
    
    // location
    var location = CLLocation()
    
    var locationName = ""
    
    // generate a singleton reference to Model
    class func singleton() -> PastCastModel {
        return pastCastModel
    }
    
}


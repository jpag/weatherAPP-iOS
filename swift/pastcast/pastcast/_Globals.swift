//
//  _Globals.swift
//  pastcast
//
//  Created by JP Gary on 7/25/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

import UIKit
import CoreLocation

var _notificationCenter = NSNotificationCenter()


class Globals {
    // dev
    // let apiRequests = "http://weather.yaapee.com/"
    // local
    let apiRequests = "http://local.weather.com/api/"
    
    // how many decmial pts do we make this
    // 10 = 73.21203 * 10 / 10 = 73.2
    let gpsdecmialpt = 1000.0
    
    let minUpdateTimeInSeconds = -30.0
    
    // does not work...
    func roundCoordinate(coord:CLLocationDegrees) -> Double{
        let rounded = Int(coord * globals.gpsdecmialpt)
        let result = Double(rounded) / globals.gpsdecmialpt
        return result
    }
}

var globals = Globals()




class NotificationEvents {
    let accel =     "NC.MotionUpdate.accel"
    let magnet =    "NC.MotionUpdate.magnet"
    let steps =     "NC.MotionUpdate.steps"
    let gyro =      "NC.MotionUpdate.gyro"
}

let _ncEvents = NotificationEvents()
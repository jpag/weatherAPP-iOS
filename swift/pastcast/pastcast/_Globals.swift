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
    let apiRequests = "http://weather.yaapee.com/api/"
    // local
    //let apiRequests = "http://local.weather.com/api/"
    
    // how many decmial pts do we make this
    // 10 = 73.21203 * 10 / 10 = 73.2
    let gpsdecmialpt = 10000.0
    
    let minUpdateTimeInSeconds = -30.0
    
    let halfHeight = CGFloat(0.75)
    
    let borderBetweenHalves = CGFloat(1.0)
    
    let tempError:CGFloat = -270.0
    
    // does not work...
    func roundCoordinate(coord:CLLocationDegrees) -> Double{
        let rounded = Int(coord * globals.gpsdecmialpt)
        let result = Double(rounded) / globals.gpsdecmialpt
        return result
    }
    
    // shuffle an array
    // http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
    func shuffle<T>(var list: Array<T>) -> Array<T> {
        for i in 0..<list.count {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.insert(list.removeAtIndex(j), atIndex: i)
        }
        return list
    }
    
    func iconWH()-> CGFloat {
        return UIScreen.mainScreen().bounds.width * 0.15
    }
}

class States {
    let tempStateOpen   = "States.tempblock.open"
    let tempStateClosed = "States.tempblock.closed"
    
}

class NotificationEvents {
    let loaderDoneAnimating =     "NC.loaderDoneAnimating"
}


class WeatherCodes {
    
    let loadlist =  [
                    "load-blue-clouds","load-blue-rain","load-blue-snow","load-blue-sunny","load-blue-tstorm",
                    "load-red-clouds","load-red-rain","load-red-snow","load-red-sunny","load-red-tstorm"
                    ]
    
    // used with dark sky.
    func getCodeFromString(val:NSString) ->NSString {
        var clear = "weather-sunny"
        var storm = "weather-tstorm"
        var rain = "weather-rain"
        var snow = "weather-snow"
        var atmosphere = "weather-clouds"
        var clouds = "weather-clouds"
        var extreme = "weather-tstorm"
        
        var tornado = "weather-tstorm"
        var hurricane = "weather-tstorm"
        
        if( val == "clear-day" ){
            return clear
        }
        
        if( val == "clear-night" ){
            return clear
        }
        
        if( val == "rain" ){
            return rain
        }
        
        if( val == "snow" ){
            return snow
        }
        
        if( val == "sleet" ){
            return snow
        }
        
        if( val == "wind" ){
            return clouds
        }
        
        if( val == "fog" ){
            return clouds
        }
        
        if( val == "cloudy" ){
            return clouds
        }
        
        if( val == "partly-cloudy-day" ){
            return clouds
        }
        if( val == "partly-cloudy-night" ){
            return clouds
        }
        
        return clear
        
    }
    
    func getCode(val:Int) -> NSString {

        var clear = "weather-sunny"
        var storm = "weather-tstorm"
        var rain = "weather-rain"
        var snow = "weather-snow"
        var atmosphere = "weather-clouds"
        var clouds = "weather-clouds"
        var extreme = "weather-tstorm"
        
        var tornado = "weather-tstorm"
        var hurricane = "weather-tstorm"
        
        if( val == 781 || val == 900 ){
            // tornado
            return tornado
        }
        if( val == 901 || val == 901 || val == 962 ){
            return hurricane
        }
        
        if( val < 100 ){
            return clear
        }else if( val < 200 ){
            return clear
        }else if( val < 300 ){
            // thunderstorm
            return storm
        }else if( val < 400 ){
            // drizzle
            return rain
            
        // }else if( val < 500 ){
            // EH?

        }else if( val < 600 ){
            // rain
            return rain
        }else if( val < 600 ){
            // snow
            return snow
        }else if( val < 800 ){
            // atmosphere
            // mist,smoke,haze,sand,dust,volcanic ash, squalls, tornado
            return atmosphere
        }else if( val < 900 ){
            // clouds
            return clouds
        }else if( val < 950 ){
            // extreme
            return extreme
        }else if( val < 959 ){
            // additional
            // setting, calm, light breeze, gentle breeze, moderate breeze, fresh breeze, strong breeze, high wind,
            // gale
            return atmosphere
        }else if( val < 959 ){
            // severe gale, storm, violent storm,
            // hurricane
            return storm
        }
        
        return clear
    }
}


let globals = Globals()
let appStates = States()
let weatherCodes = WeatherCodes()
let _ncEvents = NotificationEvents()

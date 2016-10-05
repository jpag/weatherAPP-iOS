//
//  _Globals.swift
//  pastcast
//
//  Created by JP Gary on 7/25/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

import UIKit
import CoreLocation

var _notificationCenter = NotificationCenter()

public typealias ErrorTup = (show:Bool,msg:String,notifyUs:Bool)

class Globals {
    
    // dev
    // let apiRequests = "http://weather.yaapee.com/api/"
    // local
    let apiRequests = "http://local.pastcast.com/api/"
    
    let loaderLarge = "State.Loader.Full.onStart"
    let loaderSmall = "State.Loader.Small"
    
    // how many decmial pts do we make this
    // 10 = 73.21203 * 10 / 10 = 73.2
    let gpsdecmialpt = 10000.0
    
    let minUpdateTimeInSeconds = -30.0
    
    let halfHeight = CGFloat(0.75)
    
    let borderBetweenHalves = CGFloat(1.0)
    
    let tempError:CGFloat = -270.0
    
    let errorMsg = [
        // this error msg can not be tested by show:true
        // errorMsg[0] CLLocation manager fail.
        (show:false, msg:"Unable to find your location", notifyUs:false),
        // errorMsg[1] CLLocation manager Unable to find your location
        (show:false, msg:"Unable to find your location", notifyUs:false),
        // errorMsg[2] geocoder Unable to find your location
        (show:false, msg:"Unable to find your location", notifyUs:false),
        // errorMsg[3] no placemark found.
        (show:false, msg:"Unable to find your location", notifyUs:false),
        // errorMsg[4] json response was nil
        (show:false, msg:"We were unable to connect to weather data", notifyUs:true),
        // errorMsg[5] error response was not nil
        (show:false, msg:"We were unable to connect to weather data", notifyUs:true),
        // errorMsg[6] server error status code is 404.
        (show:false, msg:"We were unable to connect to weather data", notifyUs:true),
        // errorMsg[7] error when trying to parse the json
        (show:false, msg:"We were unable to connect to weather data", notifyUs:true)
    ]
    
    // does not work...
    func roundCoordinate(_ coord:CLLocationDegrees) -> Double{
        let rounded = Int(coord * globals.gpsdecmialpt)
        let result = Double(rounded) / globals.gpsdecmialpt
        return result
    }
    
    // shuffle an array
    // http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
    func shuffle<T>(_ list: Array<T>) -> Array<T> {
        var list = list
        for i in 0..<list.count {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.insert(list.remove(at: j), at: i)
        }
        return list
    }
    
    func iconWH()-> CGFloat {
        return UIScreen.main.bounds.width * 0.15
    }
}

class States {
    let tempStateOpen   = "States.tempblock.open"
    let tempStateClosed = "States.tempblock.closed"
    
}

class NotificationEvents {
    let loaderDoneAnimating = "NC.loaderDoneAnimating"
    let showPoweredBy       = "NC.showPoweredBy"
    let hidePoweredBy       = "NC.hidePoweredBy"
}


class WeatherCodes {
    
    let loadlist =  [
                    "load-blue-clouds","load-blue-rain","load-blue-snow",
                    "load-blue-sunny","load-blue-tstorm",
                    "load-red-clouds","load-red-rain","load-red-snow",
                    "load-red-sunny","load-red-tstorm"
                    ]
    
    // used with dark sky.
    func getCodeFromString(_ val:NSString) ->NSString {
        let clear = "weather-sunny"
        let rain = "weather-rain"
        let snow = "weather-snow"
        let clouds = "weather-clouds"

        //var storm = "weather-tstorm"
        //var atmosphere = "weather-clouds"
        //var extreme = "weather-tstorm"
        //var tornado = "weather-tstorm"
        //var hurricane = "weather-tstorm"
        
        if( val == "clear-day" ){
            return clear as NSString
        }
        
        if( val == "clear-night" ){
            return clear as NSString
        }
        
        if( val == "rain" ){
            return rain as NSString
        }
        
        if( val == "snow" ){
            return snow as NSString
        }
        
        if( val == "sleet" ){
            return snow as NSString
        }
        
        if( val == "wind" ){
            return clouds as NSString
        }
        
        if( val == "fog" ){
            return clouds as NSString
        }
        
        if( val == "cloudy" ){
            return clouds as NSString
        }
        
        if( val == "partly-cloudy-day" ){
            return clouds as NSString
        }
        if( val == "partly-cloudy-night" ){
            return clouds as NSString
        }
        
        return clear as NSString
        
    }
    
    func getCode(_ val:Int) -> NSString {

        let clear = "weather-sunny"
        let storm = "weather-tstorm"
        let rain = "weather-rain"
        let snow = "weather-snow"
        let atmosphere = "weather-clouds"
        let clouds = "weather-clouds"
        let extreme = "weather-tstorm"
        let tornado = "weather-tstorm"
        let hurricane = "weather-tstorm"
        
        if( val == 781 || val == 900 ){
            // tornado
            return tornado as NSString
        }
        if( val == 901 || val == 901 || val == 962 ){
            return hurricane as NSString
        }
        
        if( val < 100 ){
            return clear as NSString
        }else if( val < 200 ){
            return clear as NSString
        }else if( val < 300 ){
            // thunderstorm
            return storm as NSString
        }else if( val < 400 ){
            // drizzle
            return rain as NSString
            
        // }else if( val < 500 ){
            // EH?

        }else if( val < 600 ){
            // rain
            return rain as NSString
        }else if( val < 600 ){
            // snow
            return snow as NSString
        }else if( val < 800 ){
            // atmosphere
            // mist,smoke,haze,sand,dust,volcanic ash, squalls, tornado
            return atmosphere as NSString
        }else if( val < 900 ){
            // clouds
            return clouds as NSString
        }else if( val < 950 ){
            // extreme
            return extreme as NSString
        }else if( val < 959 ){
            // additional
            // setting, calm, light breeze, gentle breeze, moderate breeze, fresh breeze, strong breeze, high wind,
            // gale
            return atmosphere as NSString
        }else if( val < 959 ){
            // severe gale, storm, violent storm,
            // hurricane
            return storm as NSString
        }
        
        return clear as NSString
    }
}


let globals = Globals()
let appStates = States()
let weatherCodes = WeatherCodes()
let _ncEvents = NotificationEvents()

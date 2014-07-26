//
//  ViewController.swift
//  pastcast
//
//  Created by JP Gary on 7/25/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

//
// Get location of user
//



import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var locationRecieved:NSDate?
    
    var currentResults:NSDictionary?
    var previousResults:NSDictionary?
    
    var topHalf:ViewTempBlock?
    var bottomHalf:ViewTempBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.pastCast.white()
        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action:"swipe"))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"tap"))
        
        findLocation()
        
    }
    
    func displayLoader() {
        
    }
    
    func removeLoader() {
        
    }
    
    func tap () {
        
        toggleDegrees()
    }
    
    func toggleDegrees() {
        
        if( pastCastModel.isCelsius ){
            pastCastModel.isCelsius = false
        }else {
            pastCastModel.isCelsius = true
        }
        
        // update display:
        println(" -- update degrees is C = \(pastCastModel.isCelsius) ")
        updateTemperature()
    }
    
    func swipe () {
        println(" --- SWIPE which direction ---")
        //findLocation()
    }
    
    func findLocation() {
        println("\n\n Find location ----- ")
        
        if( timeExpired() ){
        
            displayLoader()
        
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    // user has resumed app status
    func updateLocation() {
        // only update after X time since the last update...?
        findLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        // TODO add FAIL message or do nothing...
        println(" -- FAIL to locate...")
        
        showWarning("Warning", msg: "Failed to find a location.")
        // TODO add a default location? or a popup/autocomplete of location?
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // println("locations = \(locations)")
        
        if( locations.count > 0 ){
            
            stopUpdatingLocation()
            //println( pastCastModel.location )
            pastCastModel.location = locations[0] as CLLocation
            //println( pastCastModel.location )
            
            if( timeExpired() ){
                locationRecieved = NSDate()
                findLocationName()
            }else{
                println( " location received has happened recently so no need to force another update yet...")
            }
            
        }
    }
    
    
    func findLocationName() {
        var geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(
            pastCastModel.location,
            completionHandler: {(placemarks, error) in
                if error {
                    println("reverse geodcode fail: \(error.localizedDescription)")
                    
                    self.showWarning("Unable to find your location", msg: "sorry")
                    
                    self.get()
                }
                
                let pm = placemarks as [CLPlacemark]
                if pm.count > 0 {
                    self.locationNameFound(placemarks[0] as CLPlacemark)
                }
            }
        )
    }
    
    func locationNameFound(place:CLPlacemark) {

        if( place.locality ){
            pastCastModel.locationName = place.locality + ", " + place.administrativeArea
        }else if( place.subAdministrativeArea ){
            pastCastModel.locationName = place.subAdministrativeArea
        }else if( place.administrativeArea ){
            pastCastModel.locationName = place.administrativeArea
        }
        
        println( pastCastModel.locationName )
        get()
        
    }
    
    // JSON request
    // borrowed from: https://github.com/jquave/Swift-Tutorial/tree/Part7
    // http://ios-blog.co.uk/swift-tutorials/beginners-guide/developing-ios8-apps-using-swift-part-7-animations-audio-and-custom-table-view-cells/
    
    func get() {
        
        let long = roundCoordinate(pastCastModel.location.coordinate.longitude)
        let lat = roundCoordinate(pastCastModel.location.coordinate.latitude)
        let path = globals.apiRequests + "lat/\(lat)/lng/\(long)/"
        
        println(path)
        
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            
            println("Task completed")
            
            var statusCode = (response as NSHTTPURLResponse).statusCode
            println( statusCode )
            
            if( statusCode == 404 ){
                println("Could not find server")
                
                return
            }
            
            if(error) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
                return
            }
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if(err?) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error (err!.localizedDescription)")
                return
            }
            
            var results = jsonResult["timecompared"] as NSDictionary
            
            self.displayData(results)
            // Now send the JSON result to our delegate object
            // self.delegate?.didReceiveAPIResults(jsonResult)
        
            })
        
        task.resume()
    }
    
    func displayData(dataResults:NSDictionary) {
        currentResults = dataResults["present"] as? NSDictionary
        previousResults = dataResults["past"] as? NSDictionary
        
        // make sure this is on main thread or else it will break:
        if NSThread.isMainThread()
        {
            addViews();
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), { self.addViews() });
        }
        
    }
    
    func addViews() {
        println(" add Views - DISPLAY DATA")
        
        var calculatedTemps = updateTemps()
        
        var width = UIScreen.mainScreen().bounds.width
        var topHeight = UIScreen.mainScreen().bounds.height * globals.halfHeight
        var bottomY = topHeight + globals.borderBetweenHalves
        var bottomHeight = UIScreen.mainScreen().bounds.height * globals.halfHeight
        
        println( " current \(calculatedTemps.c) vs \(calculatedTemps.p)")
        println( " width \(width) h \(topHeight) \(UIScreen.mainScreen().bounds.height) half height: \(globals.halfHeight)")
        
        topHalf = ViewTempBlock(
            frame: CGRect(x: 0, y: 0, width: width, height: topHeight ),
            _temps: [calculatedTemps.c,calculatedTemps.p],
            _pos: 0,
            _state:appStates.tempStateOpen
        )
        
        bottomHalf = ViewTempBlock(
            frame: CGRect(x:0, y:bottomY, width: width, height: bottomHeight),
            _temps: [calculatedTemps.p,calculatedTemps.c],
            _pos: 1,
            _state: appStates.tempStateClosed
        )
        
        
        self.view.addSubview(topHalf)
        self.view.addSubview(bottomHalf)
        
        println(" added sub views")
        
    }
    
    
    // --------------------
    // SUPPORTING functions
    // --------------------
    
    func updateTemps() ->(c:CGFloat, p:CGFloat) {
    
        // http://stackoverflow.com/questions/24096293/assign-value-to-optional-dictionary-in-swift
    
        let cdict = currentResults? as NSDictionary
        let pdict = previousResults? as NSDictionary
    
        var ct: CGFloat? = cdict["temp"] as AnyObject? as? CGFloat
        var pt: CGFloat? = pdict["temp"] as AnyObject? as? CGFloat
    
        println( " ct \(ct) pt \(pt) ")
    
        var currentTemp = convertTemperature( ct! )
        var prevTemp = convertTemperature( pt! )
    
        return (currentTemp, prevTemp)
    }
    
    func updateTemperature() {
        
//        var currentTemp = convertTemperature(currentResults?["temp"] as NSNumber)
//        var prevTemp = convertTemperature(previousResults?["temp"] as NSNumber)
        
        if( topHalf && bottomHalf ){
            
            var calculatedTemps = updateTemps()
            topHalf?.update([calculatedTemps.c,calculatedTemps.p])
            bottomHalf?.update([calculatedTemps.p,calculatedTemps.c])
            
        }else{
            
            addViews()
        }
        
        
    }
    
    func convertTemperature( kelvin:CGFloat ) -> CGFloat {
        
        var abszero:CGFloat = 273.15
        if( pastCastModel.isCelsius ){
            // C
            return kelvin - abszero
        }else{
            // F
            return (( kelvin - abszero) * 1.8000 ) + 32
        }
    }
    
    
    func timeExpired() ->Bool {
        
        println(" - check has time gone long enough to run again?")
        println(" -location received \( locationRecieved ) interval since now \(locationRecieved?.timeIntervalSinceNow) --- ")
        
        if( locationRecieved == nil || locationRecieved?.timeIntervalSinceNow < globals.minUpdateTimeInSeconds ){
            // go ahead do another update
            println(" YES\n")
            return true
        }else{
            println(" NO\n")
            return false
        }
    }
    
    func roundCoordinate(coord:CLLocationDegrees) -> Double{
        let rounded = Int(coord * globals.gpsdecmialpt)
        let result = Double(rounded) / globals.gpsdecmialpt
        return result
    }
    
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        println(" Stop updating location")
        removeLoader()
    }
    
    func showWarning(title:String, msg:String){
        var message = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
            message.addAction(UIAlertAction(title: "K", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(message, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


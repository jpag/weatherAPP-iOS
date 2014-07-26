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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.pastCast.white()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"tap"))
        
        findLocation()
        
    }
    
    func displayLoader() {
        
    }
    
    func removeLoader() {
        
    }
    
    func tap () {
        
        findLocation()
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
    
    func timeExpired() ->Bool {
        
        println("\n -- check has time gone long enough to run again?")
        println("\n location received \( locationRecieved ) interval since now \(locationRecieved?.timeIntervalSinceNow) --- ")
        
        if( locationRecieved == nil || locationRecieved?.timeIntervalSinceNow < globals.minUpdateTimeInSeconds ){
            // go ahead do another update
            println(" YES\n\n")
            return true
        }else{
            println(" NO\n\n")
            return false
        }
    }
        
        
    // user has resumed app status
    func updateLocation() {
        // only update after X time since the last update...?
        
        findLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        // TODO add FAIL message or do nothing...
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //println("locations = \(locations)")
        if( locations.count > 0 ){
            
            stopUpdatingLocation()
            
            //println( pastCastModel.location )
            pastCastModel.location = locations[0] as CLLocation
            println( pastCastModel.location )
            
            if( timeExpired() ){
                locationRecieved = NSDate()
                get()
            }else{
                println( " location received has happened recently so no need to force another update yet...")
            }
            
            
        }
    }
    
    
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
            
            if(error) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if(err?) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error (err!.localizedDescription)")
            }
            
            var results = jsonResult["timecompared"] as NSObject
            
            self.displayData(results)
            // Now send the JSON result to our delegate object
            // self.delegate?.didReceiveAPIResults(jsonResult)
        
            })
        
        task.resume()
    }
    
    func roundCoordinate(coord:CLLocationDegrees) -> Double{
        let rounded = Int(coord * globals.gpsdecmialpt)
        let result = Double(rounded) / globals.gpsdecmialpt
        return result
    }
    
    func displayData(results:NSObject) {
        println(" DISPLAY DATA")
        
        // this is used to prevent multiple requests for data.
        // reset this for the next update once we have drawn the data to stage.
        println(locationRecieved)
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        println(" Stop updating location")
        
        removeLoader()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


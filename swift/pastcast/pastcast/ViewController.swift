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


class ViewController: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {
    
    var locationManager = CLLocationManager()
    var dataRecieved:NSDate?
    
    var currentResults:NSDictionary?
    var previousResults:NSDictionary?
    
    var topHalf:ViewTempBlock?
    var bottomHalf:ViewTempBlock?
    
    // scroll
    var scrollTop = (current:CGFloat(0.0),previous:CGFloat(0.0))
    var scrollTimer:NSTimer?
    var scrollViewDestination:CGFloat?
    
    // loader
    var loaderView:ViewLoading?
    
    // error stuff
    var errorMsg:ViewError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //UIFont.cycleThroughSysFonts()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        var newFrame = self.view.frame
            newFrame.size.height = (UIScreen.mainScreen().bounds.height * globals.halfHeight) * 2
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"tap"))
        
        var scrollView = self.view as UIScrollView
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.decelerationRate = 0.75
        scrollView.showsVerticalScrollIndicator = false
        
        _notificationCenter.addObserverForName(_ncEvents.loaderDoneAnimating, object: nil, queue: nil, usingBlock: loaderDoneAnimating )
        
        findLocation()
    
    }
    
    func setScrollViewHeight(newH:CGFloat) {
        println(" Set scroll view \(newH)")
        var scrollView = self.view as UIScrollView
        scrollView.contentSize = CGSize(width:  UIScreen.mainScreen().bounds.width, height: newH )
    }
    
    func tap () {
        if( errorMsg != nil ){
            removeWarning()
        }else{
            toggleDegrees()
        }
    }
    
    
    func showLoader(){
        println(" show loader ---- ")
        
        setScrollViewHeight(UIScreen.mainScreen().bounds.height);
        _notificationCenter.postNotificationName(_ncEvents.hidePoweredBy, object: nil)
        
        var width = UIScreen.mainScreen().bounds.width
        var height = UIScreen.mainScreen().bounds.height
        
        
        /*
        for view in self.view.subviews {
            println(" removing view ")
            view.removeFromSuperview();
        }
        */
        
        if( self.topHalf? != nil && self.bottomHalf? != nil ){
            println(" top and bottom half exists.")
            // add the bottom loader display:
            
            var bottomHeight = UIScreen.mainScreen().bounds.height * (1.0 - globals.halfHeight)
            var y = UIScreen.mainScreen().bounds.height
            loaderView = ViewLoading( frame: CGRect(x: 0, y:y, width: width, height: bottomHeight), loaderType: globals.loaderSmall)
            self.view.addSubview(loaderView!)
            loaderView?.animateInOnSmall()
        }else{
            loaderView = ViewLoading( frame: CGRect(x: 0, y:0, width: width, height: height), loaderType: globals.loaderLarge)
            self.view.addSubview(loaderView!)

        }
    }
    
    func removeLoader(type:NSString) {
        println(" --- view controller removeLoader() ")
        if( loaderView != nil ){
            loaderView!.removeLoader(type)
        }else{
            // no loader.. skip to adding views
            // self.loaderDoneAnimating(nil)
            if( type == "ADDVIEWS"){
                self.readyToAddViews()
            }
        }
    }
    
    func loaderDoneAnimating(obj:NSNotification!){
        var vals = obj.object as NSDictionary
        var type = vals["type"] as NSString
        
        println( " TYPE for loader being done \(type)" )
        
        loaderView?.removeFromSuperview()
        loaderView = nil
        
        if( type == "ADDVIEWS"){
            readyToAddViews()
        }else{
            
        }
    }
    
    func toggleDegrees() {
        
        if( pastCastModel.isCelsius ){
            pastCastModel.isCelsius = false
        }else {
            pastCastModel.isCelsius = true
        }
        
        // update display:
        println(" -- update degrees is C = \(pastCastModel.isCelsius) ")
        updateDisplay()
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView){
        // println(" user scrolling \(scrollView.contentOffset.y)")
        
        var maxScrollY = getMaxScroll()
        
        scrollTop.previous = scrollTop.current
        scrollTop.current = scrollView.contentOffset.y
        
        if( scrollView.contentOffset.y < 0 ){
            // pull to refresh!
            
        }else if( scrollView.contentOffset.y > maxScrollY ){
            scrollView.contentOffset.y = maxScrollY
        }
        
        // update the two temperature views:
        topHalf?.updateState( scrollView.contentOffset.y / maxScrollY )
        bottomHalf?.updateState( scrollView.contentOffset.y / maxScrollY )
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        println(" scrollViewDidEndDecelerating ")
        snapTo(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView!) {
        println(" scrollViewWillBeginDecelerating ")
        
        if( scrollView.contentOffset.y >= 0 ){
            // scrollView.setContentOffset(scrollView.contentOffset, animated: true)
        }
        
        //snapTo(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        println( " Scroll view did end dragging decelerate: \(decelerate)")
        if( !decelerate){
            snapTo(scrollView)
        }
    }
    
    func snapTo(scrollView:UIScrollView) {
        println(" snap to ")
        
        var maxScrollY          = getMaxScroll()
        var snapto:CGFloat      = 0
        var halfwayPt:CGFloat   = maxScrollY * 0.5
        
        var direction:NSString  = "up"
        if( scrollTop.current > scrollTop.previous ){
            direction = "down"
        }
        
        //println( scrollView.contentOffset.y )
        //println(" direction \(direction) scrolltop current \(scrollTop.current) prev \(scrollTop.previous) ---")
        
        if( scrollTop.current < 0 ){
            // let it go back on it's own
            // println( " Do not animate")
            // scrollView.removeAllAnimations()
            return
        }else if( scrollTop.current > (maxScrollY * 0.15) && direction == "down" ){
            snapto = maxScrollY
        }else if( scrollTop.current < (maxScrollY * 0.65) && direction == "up" ){
            snapto = 0
        }else if( scrollTop.current > halfwayPt ){
            // stay to where you are closest:
            snapto = maxScrollY
        }else if( scrollTop.current < halfwayPt ){
            // stay to where you are closest:
            snapto = 0
        }
        
        var distance = Double( abs( scrollView.contentOffset.y - snapto) )
        var timePerPixel = Double(0.0025)
        var time:Double = distance * timePerPixel
        
        if( scrollTimer? != nil ){
            scrollTimer?.invalidate()
        }
        scrollViewDestination = snapto
        scrollTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("stepAnimate"), userInfo: nil, repeats: true)
        // TODO should we disable fire()
        scrollTimer?.fire()
    }
    
    func stepAnimate() {
        //println(" ---- step animate ---")
        
        if( scrollViewDestination == nil ){
            println(" did not find a ST destination so cancel the animation timer")
            println(" ---- Invalidate ---- ")
            scrollTimer?.invalidate()
            return
        }
        var maxScrollY          = getMaxScroll()
        var scrollView = self.view as UIScrollView
        var increment:CGFloat = 0.1 //0.05
        
        var newST:CGFloat = scrollView.contentOffset.y - ((scrollView.contentOffset.y - scrollViewDestination!) * increment)
        var difST:CGFloat = abs(scrollView.contentOffset.y - newST)
        if( difST < 0.5 ){
            println(" ---- Invalidate ---- ")
            // close enough stop the animation
            scrollTimer?.invalidate()
            newST = scrollViewDestination!
        }
        
        //println( "scrollViewDestination: \(scrollViewDestination) ----- | scrollView.contentOffset.y \(scrollView.contentOffset.y) = newST \(newST) " )
        //println( " difffffst \(difST) ")
        
        scrollView.contentOffset.y = newST
        
        // update the two temperature views:
        topHalf?.updateState( scrollView.contentOffset.y / maxScrollY )
        bottomHalf?.updateState( scrollView.contentOffset.y / maxScrollY )
    }
    
    func getMaxScroll() -> CGFloat {
        return UIScreen.mainScreen().bounds.height * (globals.halfHeight * 2) - UIScreen.mainScreen().bounds.height
    }
    
    // user has resumed app status
    func updateLocation() {
        // clear the existing views:
        findLocation()
    }
    
    func findLocation() {
        
        println("\n\n Find location ----- ")
        if( timeExpired() ){
            showLoader()
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(" -- FAIL to locate...")
        stopUpdatingLocation()
        showWarning(globals.errorMsg[0].msg)
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // println("locations = \(locations)")
        
        if( locations.count > 0 && !globals.errorMsg[1].show ){
            stopUpdatingLocation()
            pastCastModel.location = locations[0] as CLLocation
            findLocationName()
        }else{
            stopUpdatingLocation()
            showWarning(globals.errorMsg[1].msg)
        }
    }
    
    func findLocationName() {
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(
            pastCastModel.location,
            completionHandler: {(placemarks, error) in
                if (error != nil || globals.errorMsg[2].show ) {
                    //println("reverse geodcode fail: \(error.localizedDescription)")
                    println( "reverse geodcode fail" )
                    self.showWarning(globals.errorMsg[2].msg)
                    return;
                }
                let pm = placemarks as [CLPlacemark]
                
                if( pm.count > 0 && !globals.errorMsg[3].show ){
                    self.locationNameFound(placemarks[0] as CLPlacemark)
                }else{
                   self.showWarning(globals.errorMsg[3].msg)
                }
            }
        )
    }
    
    func locationNameFound(place:CLPlacemark) {

        if(( place.locality ) != nil){
            pastCastModel.locationName = place.locality + ", " + place.administrativeArea
        }else if(( place.subAdministrativeArea ) != nil){
            pastCastModel.locationName = place.subAdministrativeArea
        }else if(( place.administrativeArea ) != nil){
            pastCastModel.locationName = place.administrativeArea
        }
        
        println( pastCastModel.locationName )
        getJSON()
    }
    
    // JSON request
    // borrowed from: https://github.com/jquave/Swift-Tutorial/tree/Part7
    // http://ios-blog.co.uk/swift-tutorials/beginners-guide/developing-ios8-apps-using-swift-part-7-animations-audio-and-custom-table-view-cells/
    
    func getJSON() {
        let long = roundCoordinate(pastCastModel.location.coordinate.longitude)
        let lat = roundCoordinate(pastCastModel.location.coordinate.latitude)
        let path = globals.apiRequests + "lat/\(lat)/lng/\(long)/"
        
        println(path)
        
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
            
            if( response == nil || globals.errorMsg[4].show ){
                self.showWarning(globals.errorMsg[4].msg)
                return
            }
            
            if((error) != nil || globals.errorMsg[5].show ) {
                // If there is an error in the web request, print it to the console
                // println(error.localizedDescription)
                println(" web request error")
                self.showWarning(globals.errorMsg[5].msg)
                return
            }
            
            var statusCode = (response as NSHTTPURLResponse).statusCode
            println("--- JSON loaded --- http status code \(statusCode)")
            
            if( statusCode == 404 || globals.errorMsg[6].show ){
                println("Could not find server")
                self.showWarning(globals.errorMsg[6].msg)
                return
            }

            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if( (err?) != nil || globals.errorMsg[7].show) {
                // If there is an error parsing JSON, print it to the console
                self.showWarning(globals.errorMsg[7].msg)
                return
            }
            
            var results = jsonResult["timecompared"] as NSDictionary
            self.dataRecieved = NSDate()
            self.displayData(results)
            // once the loader is removed the views will be added.
            self.removeLoader("ADDVIEWS")
            
        })
        
        task.resume()
    }
    
    func displayData(dataResults:NSDictionary) {
        currentResults = dataResults["present"] as? NSDictionary
        previousResults = dataResults["past"] as? NSDictionary
    }
    
    // we wait for the loader to be done in a sequence before displaying the views.
    func readyToAddViews() {
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
        
        setScrollViewHeight(UIScreen.mainScreen().bounds.height * (globals.halfHeight*2.0));
        _notificationCenter.postNotificationName(_ncEvents.showPoweredBy, object: nil)
        
        var calculatedTemps = updateTemps()
        
        if( calculatedTemps.c == globals.tempError || calculatedTemps.p == globals.tempError ){
            println(" - warning views cal time..not valid \(globals.tempError) ")
            return
        }
        
        var width = UIScreen.mainScreen().bounds.width as CGFloat
        var halfheight = UIScreen.mainScreen().bounds.height * globals.halfHeight
        var topHeight = halfheight
        var bottomY = topHeight + globals.borderBetweenHalves
        var bottomHeight = halfheight
        
        var _weatherCodes: (present:NSString,past:NSString) = self.getWeatherCodes()
        
        println( " current \(calculatedTemps.c) vs \(calculatedTemps.p)")
        //println( " width \(width) h \(topHeight) \(UIScreen.mainScreen().bounds.height) half height: \(globals.halfHeight)")
        
        println( "Weather codes Past:\(_weatherCodes.past) & Present:\(_weatherCodes.present)" )
        
        topHalf = ViewTempBlock(
            frame: CGRect(x: 0, y: 0, width: width, height: topHeight ),
            _temps: [calculatedTemps.c,calculatedTemps.p],
            _weathercode : _weatherCodes.present,
            _pos: 0,
            _state:appStates.tempStateOpen
        )
        
        bottomHalf = ViewTempBlock(
            frame: CGRect(x: 0, y:bottomY, width: width, height: bottomHeight),
            _temps: [calculatedTemps.p,calculatedTemps.c],
            _weathercode : _weatherCodes.past,
            _pos: 1,
            _state: appStates.tempStateClosed
        )
        
        var maxScrollY = getMaxScroll()
        var scrollViewY = (self.view as UIScrollView).contentOffset.y
        
        topHalf?.updateState( scrollViewY / maxScrollY )
        bottomHalf?.updateState( scrollViewY / maxScrollY )
        
        self.view.addSubview(topHalf!)
        self.view.addSubview(bottomHalf!)
        
        println(" added sub views")
        
    }
    
    
    // --------------------
    // SUPPORTING functions
    // --------------------
    
    func updateTemps() ->(c:CGFloat, p:CGFloat) {
    
        if( currentResults? == nil || previousResults? == nil ){
            return (globals.tempError, globals.tempError)
        }
        
        let cdict = currentResults! as NSDictionary
        let pdict = previousResults! as NSDictionary
    
        var ct: CGFloat? = cdict["temp"] as AnyObject? as? CGFloat
        var pt: CGFloat? = pdict["temp"] as AnyObject? as? CGFloat
    
        println( " ct \(ct) pt \(pt) ")
    
        var currentTemp = convertTemperature( ct! )
        var prevTemp = convertTemperature( pt! )
    
        return (currentTemp, prevTemp)
    }
    
    func getWeatherCodes()->(present:NSString,past:NSString) {
        let cdict = currentResults! as NSDictionary
        let pdict = previousResults! as NSDictionary
        
        var present:NSString? = cdict["weathercode"] as AnyObject? as? NSString
        var past:NSString? = pdict["weathercode"] as AnyObject? as? NSString
        
        var results: (present: NSString, past: NSString) = (present!,past!)
        return results
    }
    
    func updateDisplay() {
        if( topHalf != nil && bottomHalf != nil){
            
            var calculatedTemps = updateTemps()
            
            if( calculatedTemps.c == globals.tempError || calculatedTemps.p == globals.tempError ){
                print("ERROR could not update")
                return
            }
            
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
        // dataRecieved is updated once JSON request is made and successful
        
        println(" - check has time gone long enough to run again?")
        
        return true
        
        /*
        if( dataRecieved == nil || dataRecieved?.timeIntervalSinceNow < globals.minUpdateTimeInSeconds ){
            // go ahead do another update
            println("  YES\n")
            return true
        }else{
            println(" NO\n")
            return false
        }
        */
        
    }
    
    func roundCoordinate(coord:CLLocationDegrees) -> Double{
        let rounded = Int(coord * globals.gpsdecmialpt)
        let result = Double(rounded) / globals.gpsdecmialpt
        return result
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        println(" Stop updating location")
    }
    
    func showWarning(msg:String){
        if NSThread.isMainThread(){
            showWarningMainThread(msg);
        }else{
            dispatch_sync(dispatch_get_main_queue(), { self.showWarningMainThread(msg) });
        }
    }
    
    func showWarningMainThread(msg:String){
        
        self.removeLoader("NA")
        setScrollViewHeight(UIScreen.mainScreen().bounds.height);
        _notificationCenter.postNotificationName(_ncEvents.hidePoweredBy, object: nil)
        
        var width = UIScreen.mainScreen().bounds.width
        var height = UIScreen.mainScreen().bounds.height
        
        println(" SHOW error view")
        
        if( errorMsg == nil ){
            println(" error msg was nil")
            errorMsg = ViewError( frame: CGRect(x: 0, y:0.0, width: width, height: height), errorMsg: msg )
        }else{
            // remove the existing error and show this one ?
            println(" error msg already exists")
            // update the error msg :
            errorMsg?.updateError(msg)
        }
        
        self.view.addSubview(errorMsg!)
        
    }
    
    func removeWarning() {
        
        if( errorMsg != nil ){
            self.errorMsg?.removeFromSuperview()
            self.errorMsg = nil
        }
        // reset dataRecieved resets timeexpired range
        dataRecieved = nil
        
        println("Start over again:")
        // start over again:
        findLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ViewController: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {
    
    var locationManager = CLLocationManager()
    var dataRecieved:Date?
    
    var currentResults:NSDictionary?
    var previousResults:NSDictionary?
    
    var topHalf:ViewTempBlock?
    var bottomHalf:ViewTempBlock?
    
    // scroll
    var scrollView:UIScrollView = UIScrollView()
    
    var scrollTop = (current:CGFloat(0.0),previous:CGFloat(0.0))
    var scrollTimer:Timer?
    var scrollViewDestination:CGFloat?
    
    // loader
    var loaderView:ViewLoading?
    
    // error stuff
    var errorMsg:ViewError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //UIFont.cycleThroughSysFonts()
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        //        var newFrame = self.view.frame
        //        newFrame.size.height = (UIScreen.mainScreen().bounds.height * globals.halfHeight) * 2
        //        var scrollView = self.view as! UIScrollView
        let scrollHeight = (UIScreen.main.bounds.height * globals.halfHeight) * 2
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: scrollHeight))
        self.scrollView.isScrollEnabled = true
        self.scrollView.delegate = self
        self.scrollView.decelerationRate = 0.75
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(ViewController.tap)))
        
        let poweredBy = ViewPoweredBy()
        self.view.addSubview(poweredBy)
        
        self.view.addSubview(self.scrollView)
        
        
        if( self.scrollView.frame.origin.y > 0 ){
            self.scrollView.frame.offsetInPlace(dx: 0, dy: self.scrollView.frame.origin.y * -1.0 )
        }
        
        
//        self.scrollView.backgroundColor = UIColor.pastCast.blue(alpha: 0.75)
        self.view.backgroundColor = UIColor.pastCast.white()
        
        print( self.scrollView.bounds )
        print( self.scrollView.frame )
        
        _notificationCenter.addObserver(forName: _ncEvents.loaderDoneAnimating, object: nil, queue: nil, using: loaderDoneAnimating )
        
        findLocation()
        //self.showWarning(globals.errorMsg[5])
        
    }
    
    func setScrollViewHeight(_ newH:CGFloat) {
        print(" Set scroll view \(newH)")
        let scrollView = self.scrollView
        scrollView.contentSize = CGSize(width:  UIScreen.main.bounds.width, height: newH )
    }
    
    func tap () {
        if( errorMsg != nil ){
            removeWarning()
        }else{
            toggleDegrees()
        }
    }
    
    
    func showLoader(){
        print(" show loader ---- ")
        
        setScrollViewHeight(UIScreen.main.bounds.height);
        _notificationCenter.post(name: Notification.Name(rawValue: _ncEvents.hidePoweredBy), object: nil)
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        
        /*
        for view in self.scrollView.subviews {
        println(" removing view ")
        view.removeFromSuperview();
        }
        */
        
        if( self.topHalf != nil && self.bottomHalf != nil ){
            print(" top and bottom half exists.")
            // add the bottom loader display:
            
            let bottomHeight = UIScreen.main.bounds.height * (1.0 - globals.halfHeight)
            let y = UIScreen.main.bounds.height
            loaderView = ViewLoading( frame: CGRect(x: 0, y:y, width: width, height: bottomHeight), loaderType: globals.loaderSmall as NSString)
            self.scrollView.addSubview(loaderView!)
            loaderView?.animateInOnSmall()
        }else{
            loaderView = ViewLoading( frame: CGRect(x: 0, y:0, width: width, height: height), loaderType: globals.loaderLarge as NSString)
            self.scrollView.addSubview(loaderView!)
            
        }
    }
    
    func removeLoader(_ type:NSString) {
        print(" --- view controller removeLoader() ")
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
    
    func loaderDoneAnimating(_ obj:Notification!){
        let vals = obj.object as! NSDictionary
        let type = vals["type"] as! NSString
        
        print( " TYPE for loader being done \(type)" )
        
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
        print(" -- update degrees is C = \(pastCastModel.isCelsius) ")
        updateDisplay()
    }
    
    func scrollViewDidScroll(_ scrollView:UIScrollView){
        // println(" user scrolling \(scrollView.contentOffset.y)")
        
        let maxScrollY = getMaxScroll()
        
        scrollTop.previous = scrollTop.current
        scrollTop.current = scrollView.contentOffset.y
        
        if( scrollView.contentOffset.y < 0 ){
            // pull to refresh!
            print(" --- we are going far enough to load tomorrow? \(scrollView.contentOffset.y)")
            
        }else if( scrollView.contentOffset.y > maxScrollY ){
            scrollView.contentOffset.y = maxScrollY
        }
        
        // update the two temperature views:
        topHalf?.updateState( scrollView.contentOffset.y / maxScrollY )
        bottomHalf?.updateState( scrollView.contentOffset.y / maxScrollY )
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(" scrollViewDidEndDecelerating ")
        snapTo(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print(" scrollViewWillBeginDecelerating ")
        
        if( scrollView.contentOffset.y >= 0 ){
            // scrollView.setContentOffset(scrollView.contentOffset, animated: true)
        }
        
        //snapTo(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print( " Scroll view did end dragging decelerate: \(decelerate)")
        if( !decelerate){
            snapTo(scrollView)
        }
    }
    
    func snapTo(_ scrollView:UIScrollView) {
        print(" snap to ")
        
        let maxScrollY          = getMaxScroll()
        var snapto:CGFloat      = 0
        let halfwayPt:CGFloat   = maxScrollY * 0.5
        
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
        
        //let distance = Double( abs( scrollView.contentOffset.y - snapto) )
        //let timePerPixel = Double(0.0025)
        // var time:Double = distance * timePerPixel
        
        if( scrollTimer != nil ){
            scrollTimer?.invalidate()
        }
        
        scrollViewDestination = snapto
        scrollTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.stepAnimate), userInfo: nil, repeats: true)
        // TODO should we disable fire()
        scrollTimer?.fire()
    }
    
    func stepAnimate() {
        //println(" ---- step animate ---")
        
        if( scrollViewDestination == nil ){
            print(" did not find a ST destination so cancel the animation timer")
            print(" ---- Invalidate ---- ")
            scrollTimer?.invalidate()
            return
        }
        let maxScrollY          = getMaxScroll()
        let scrollView = self.scrollView
        let increment:CGFloat = 0.1 //0.05
        
        var newST:CGFloat = scrollView.contentOffset.y - ((scrollView.contentOffset.y - scrollViewDestination!) * increment)
        let difST:CGFloat = abs(scrollView.contentOffset.y - newST)
        if( difST < 0.5 ){
            print(" ---- Invalidate ---- ")
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
        return UIScreen.main.bounds.height * (globals.halfHeight * 2) - UIScreen.main.bounds.height
    }
    
    // user has resumed app status
    func updateLocation() {
        // clear the existing views:
        findLocation()
    }
    
    func findLocation() {
        
        print("\n\n Find location ----- ")
        if( timeExpired() ){
            showLoader()
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\n\n -- FAIL to locate...")
        print(error)
        
        stopUpdatingLocation()
        self.showWarning(globals.errorMsg[0])
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\n\n -- locations = \(locations)")
        
        if( locations.count > 0 && !globals.errorMsg[1].show ){
            stopUpdatingLocation()
            pastCastModel.location = locations[0] 
            findLocationName()
        }else{
            stopUpdatingLocation()
            self.showWarning(globals.errorMsg[1])
        }
    }
    
    func findLocationName() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(
            pastCastModel.location,
            completionHandler: {(placemarks, error) in
                if (error != nil || globals.errorMsg[2].show ) {
                    //println("reverse geodcode fail: \(error.localizedDescription)")
                    print( "reverse geodcode fail" )
                    self.showWarning(globals.errorMsg[2])
                    return;
                }
                let pm = placemarks as [CLPlacemark]?
                
                if( pm!.count > 0 && !globals.errorMsg[3].show ){
                    self.locationNameFound(placemarks![0] )
                }else{
                    self.showWarning(globals.errorMsg[3])
                }
            }
        )
    }
    
    func locationNameFound(_ place:CLPlacemark) {
        
        if(( place.locality ) != nil){
            pastCastModel.locationName = place.locality! + ", " + place.administrativeArea!
        }else if(( place.subAdministrativeArea ) != nil){
            pastCastModel.locationName = place.subAdministrativeArea!
        }else if(( place.administrativeArea ) != nil){
            pastCastModel.locationName = place.administrativeArea!
        }
        
        print( pastCastModel.locationName )
        getJSON()
    }
    
    // JSON request
    // borrowed from: https://github.com/jquave/Swift-Tutorial/tree/Part7
    // http://ios-blog.co.uk/swift-tutorials/beginners-guide/developing-ios8-apps-using-swift-part-7-animations-audio-and-custom-table-view-cells/
    
    func getJSON() {
        let long = roundCoordinate(pastCastModel.location.coordinate.longitude)
        let lat = roundCoordinate(pastCastModel.location.coordinate.latitude)
        let path = globals.apiRequests + "lat/\(lat)/lng/\(long)/"
        
        print("-- loading json --")
        print(path)
        
        let url = URL(string: path)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: { data, response, error -> Void in
            
            if( response == nil || globals.errorMsg[4].show ){
                print("------ resonse was nil from server.")
                self.showWarning(globals.errorMsg[4])
                return
            }
            
            if((error) != nil || globals.errorMsg[5].show ) {
                // If there is an error in the web request, print it to the console
                // println(error.localizedDescription)
                print(" web request error")
                self.showWarning(globals.errorMsg[5])
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("--- JSON loaded --- http status code \(statusCode)")
            
            if( statusCode == 404 || globals.errorMsg[6].show ){
                print("Could not find server")
                self.showWarning(globals.errorMsg[6])
                return
            }
            
            //let err: NSError?
            let jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            
            if( globals.errorMsg[7].show) {
                // If there is an error parsing JSON, print it to the console
                self.showWarning(globals.errorMsg[7])
                return
            }
            
            let results = jsonResult["timecompared"] as! NSDictionary
            self.dataRecieved = Date()
            self.displayData(results)
            // once the loader is removed the views will be added.
            self.removeLoader("ADDVIEWS")
            
        })
        
        task.resume()
    }
    
    func displayData(_ dataResults:NSDictionary) {
        currentResults = dataResults["present"] as? NSDictionary
        previousResults = dataResults["past"] as? NSDictionary
    }
    
    // we wait for the loader to be done in a sequence before displaying the views.
    func readyToAddViews() {
        // make sure this is on main thread or else it will break:
        if Thread.isMainThread
        {
            addViews();
        }
        else
        {
            DispatchQueue.main.sync(execute: { self.addViews() });
        }
    }
    
    func addViews() {
        print(" add Views - DISPLAY DATA")
        
        setScrollViewHeight(UIScreen.main.bounds.height * (globals.halfHeight*2.0));
        _notificationCenter.post(name: Notification.Name(rawValue: _ncEvents.showPoweredBy), object: nil)
        
        let calculatedTemps = updateTemps()
        
        if( calculatedTemps.c == globals.tempError || calculatedTemps.p == globals.tempError ){
            print(" - warning views cal time..not valid \(globals.tempError) ")
            return
        }
        
        let width = UIScreen.main.bounds.width as CGFloat
        let halfheight = UIScreen.main.bounds.height * globals.halfHeight
        let topHeight = halfheight
        let bottomY = topHeight + globals.borderBetweenHalves
        let bottomHeight = halfheight
        
        let _weatherCodes: (present:NSString,past:NSString) = self.getWeatherCodes()
        
        print( " current \(calculatedTemps.c) vs \(calculatedTemps.p)")
        //println( " width \(width) h \(topHeight) \(UIScreen.mainScreen().bounds.height) half height: \(globals.halfHeight)")
        
        print( "Weather codes Past:\(_weatherCodes.past) & Present:\(_weatherCodes.present)" )
        
        topHalf = ViewTempBlock(
            frame: CGRect(x: 0, y: 0, width: width, height: topHeight ),
            _temps: [calculatedTemps.c,calculatedTemps.p],
            _weathercode : _weatherCodes.present,
            _pos: 0,
            _state:appStates.tempStateOpen as NSString
        )
        
        bottomHalf = ViewTempBlock(
            frame: CGRect(x: 0, y:bottomY, width: width, height: bottomHeight),
            _temps: [calculatedTemps.p,calculatedTemps.c],
            _weathercode : _weatherCodes.past,
            _pos: 1,
            _state: appStates.tempStateClosed as NSString
        )
        
        let maxScrollY = getMaxScroll()
        let scrollViewY = (self.scrollView).contentOffset.y
        
        topHalf?.updateState( scrollViewY / maxScrollY )
        bottomHalf?.updateState( scrollViewY / maxScrollY )
        
        self.scrollView.addSubview(topHalf!)
        self.scrollView.addSubview(bottomHalf!)
        
        print(" added sub views")
        
    }
    
    
    // --------------------
    // SUPPORTING functions
    // --------------------
    
    func updateTemps() ->(c:CGFloat, p:CGFloat) {
        
        if( currentResults == nil || previousResults == nil ){
            return (globals.tempError, globals.tempError)
        }
        
        let cdict = currentResults! as NSDictionary
        let pdict = previousResults! as NSDictionary
        
        let ct: CGFloat? = cdict["temp"] as AnyObject? as? CGFloat
        let pt: CGFloat? = pdict["temp"] as AnyObject? as? CGFloat
        
        print( " ct \(ct) pt \(pt) ")
        
        let currentTemp = convertTemperature( ct! )
        let prevTemp = convertTemperature( pt! )
        
        return (currentTemp, prevTemp)
    }
    
    func getWeatherCodes()->(present:NSString,past:NSString) {
        let cdict = currentResults! as NSDictionary
        let pdict = previousResults! as NSDictionary
        
        let present:NSString? = cdict["weathercode"] as AnyObject? as? NSString
        let past:NSString? = pdict["weathercode"] as AnyObject? as? NSString
        
        let results: (present: NSString, past: NSString) = (present!,past!)
        return results
    }
    
    func updateDisplay() {
        if( topHalf != nil && bottomHalf != nil){
            
            let calculatedTemps = updateTemps()
            
            if( calculatedTemps.c == globals.tempError || calculatedTemps.p == globals.tempError ){
                print("ERROR could not update", terminator: "")
                return
            }
            
            topHalf?.update([calculatedTemps.c,calculatedTemps.p])
            bottomHalf?.update([calculatedTemps.p,calculatedTemps.c])
            
        }else{
            addViews()
        }
    }
    
    func convertTemperature( _ kelvin:CGFloat ) -> CGFloat {
        
        let abszero:CGFloat = 273.15
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
        
        print(" - check has time gone long enough to run again?")
        
        //return true
        
        
        if( dataRecieved == nil || dataRecieved?.timeIntervalSinceNow < globals.minUpdateTimeInSeconds ){
            // go ahead do another update
            print("  YES\n")
            return true
        }else{
            print(" NO\n")
            return false
        }
        
        
    }
    
    func roundCoordinate(_ coord:CLLocationDegrees) -> Double{
        let rounded = Int(coord * globals.gpsdecmialpt)
        let result = Double(rounded) / globals.gpsdecmialpt
        return result
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        print(" Stop updating location")
    }
    
    func showWarning(_ error:ErrorTup){
        if Thread.isMainThread{
            showWarningMainThread(error);
        }else{
            DispatchQueue.main.sync(execute: { self.showWarningMainThread(error) });
        }
    }
    
    func showWarningMainThread(_ error:ErrorTup){
        
        self.removeLoader("NA")
        
        setScrollViewHeight(UIScreen.main.bounds.height);
        _notificationCenter.post(name: Notification.Name(rawValue: _ncEvents.hidePoweredBy), object: nil)
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        print(" SHOW error view")
        
        if( errorMsg == nil ){
            print(" error msg was nil")
            errorMsg = ViewError( frame: CGRect(x: 0, y:0.0, width: width, height: height), errorMsg: error.msg as NSString, notifyUs:error.notifyUs )
        }else{
            // remove the existing error and show this one ?
            print(" error msg already exists")
            // update the error msg :
            errorMsg?.updateError(error.msg, notifyUs: error.notifyUs)
        }
        
        self.scrollView.addSubview(errorMsg!)
        
    }
    
    func removeWarning() {
        
        if( errorMsg != nil ){
            self.errorMsg?.removeFromSuperview()
            self.errorMsg = nil
        }
        // reset dataRecieved resets timeexpired range
        dataRecieved = nil
        
        print("Start over again:")
        // start over again:
        findLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


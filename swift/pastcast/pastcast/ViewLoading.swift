//
//  ViewLoading.swift
//  pastcast
//
//  Created by JP Gary on 10/11/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

import UIKit

class ViewLoading: UIView {
    
    // loader stuff
    var imageList = weatherCodes.loadlist
    var nextImageIcon = 0
    var keepAnimating = true
    // once the view is done animating in
    var doneAnimatingIn = false
    var loaderDoneReason = "NA"
    var type = ""
    var iconView:UIImageView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, loaderType:NSString) {
        
        imageList = globals.shuffle(imageList)
        type = loaderType
        
        super.init(frame:frame)
        
        // insert loader icon here:
        var loaderIcon = UIImage(named: "temp-icon")
        var iconWH = 50 as CGFloat
        var iconx = (UIScreen.mainScreen().bounds.width - iconWH) / 2
        var icony = (self.frame.height - iconWH ) / 2
        
        if( type == globals.loaderSmall ){
            // slightly different design
            // icony = (self.frame.height - iconWH )/2
        }
        
        iconView = UIImageView(image: loaderIcon )
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        iconView.frame = CGRect(x: iconx, y: icony, width: iconWH, height: iconWH)
        
        self.addSubview(iconView)
        
        if( type == globals.loaderSmall ){
            self.backgroundColor = UIColor.pastCast.white()
            
            let time:NSTimeInterval = 0.75
            let delay:NSTimeInterval = 0.0
            let options = UIViewAnimationOptions.CurveEaseOut
            var destinationY = UIScreen.mainScreen().bounds.height * globals.halfHeight
            
            UIView.animateWithDuration(
                time,
                delay: delay,
                options: options,
                animations: {
                    self.frame.origin.y = destinationY
                },
                completion: { (finished:Bool) in
                    if( finished ){
                        self.doneAnimatingIn = true
                        if( self.keepAnimating == false ){
                            // no longer needed:
                            self.animateOut(1.0)
                        }
                    }
                }
            )
        }else{
            self.doneAnimatingIn = true
        }
        
        startLoader()
    }
    
    func startLoader(){
        
        if( type == globals.loaderSmall ){
            
        }else{
        
        }
        startSpinning()
    }
    
    func startSpinning () {
        spin()
    }
    
    func spin() {
        // this loops indefintely
        let fullRotation = CGFloat(M_PI * 2)
        let duration:NSTimeInterval = 0.75
        let delay:NSTimeInterval = 0.0
        //let options = UIViewKeyframeAnimationOptions.CalculationModePaced | UIViewKeyframeAnimationOptions.Repeat | UIViewAnimationOptions.CurveLinear
        
        let options = UIViewAnimationOptions.CurveLinear
        //animateKeyframesWithDuration
        
        UIView.animateWithDuration(
            duration,
            delay: delay,
            options: options,
            animations: {
                var rotateBy = CGFloat(M_PI / 2)
                self.iconView.transform = CGAffineTransformRotate(self.iconView.transform, rotateBy)
            },
            completion: {(finished:Bool) in
                if( finished ){
                    self.spin()
                }
            }
        )
    }
    
    func removeLoader(_type:NSString) {
        println(" ----- stop and collapse loader \(self.type)")
        loaderDoneReason = _type
        keepAnimating = false
        animateOut(0.0)
    }
    
    func animateOut(delay:NSTimeInterval) {
        // animate out the view first!
        if( !self.doneAnimatingIn ){
            println(" we cant animate OUT the loader until it is done animating IN!")
            
        }else if( self.type == globals.loaderSmall ){
            var time = 0.35
            var destinationY = UIScreen.mainScreen().bounds.height
            
            UIView.animateWithDuration(time,
                delay : delay,
                options : UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    self.frame.origin.y = destinationY
                },
                completion: { (finished:Bool) in
                    if( finished ){
                        println(" stop and collapse animation FINISHED: \(self.frame.origin.y) ")
                        self.loaderDone()
                    }
                }
            )
        }else{
            loaderDone()
        }
    }
    
    func loaderDone() {
        println("------- LOADER is done dispatch event")
        var obj = [
            "type" : loaderDoneReason
        ]
        _notificationCenter.postNotificationName(_ncEvents.loaderDoneAnimating, object: obj)
    }
    
    /*
    func animateInNextLogo() {
        // next load icon:
        // println(imageList)
        
        // animate current off screen
        
        // remove it?
        
        var iconWH = globals.iconWH()
        var weatherIcon = imageList[nextImageIcon]
        var weatherIconView = UIImageView(image: UIImage(named:weatherIcon) )
        var xpt = (UIScreen.mainScreen().bounds.width - iconWH)/2
        weatherIconView.contentMode = UIViewContentMode.ScaleAspectFit
        weatherIconView.frame = CGRect(x: xpt, y: (-1 * iconWH), width: iconWH, height: iconWH)
        
        self.addSubview(weatherIconView)
        
        // add and animate
        
        nextImageIcon++
        if( nextImageIcon >= imageList.count ){
            println("reset image list!")
            // reshuffle them?
            imageList = globals.shuffle(imageList)
            nextImageIcon = 0
        }
        
        var offScreenY = UIScreen.mainScreen().bounds.height
        var midY = (offScreenY * 0.5) - (iconWH * 0.5)
        var time = 1.0
        
        UIView.animateWithDuration(time, delay: 0.0, options: .CurveEaseOut,
            animations: {
                weatherIconView.frame.origin.y = midY
            },
            completion: { (finished:Bool) in
                if( finished ){
                    if( self.keepAnimating ){
                        self.animateInNextLogo()
                    }
                    UIView.animateWithDuration(time, delay: 0.0, options: .CurveEaseIn,
                        animations: {
                            weatherIconView.frame.origin.y = offScreenY
                        },
                        completion: {
                            (done:Bool) in
                            if( done ){
                                weatherIconView.removeFromSuperview()
                                if( self.keepAnimating ){
                                    
                                }else{
                                    self.loaderDone()
                                }
                            }
                        }
                    )
                    
                }
        })
    }
    */
    
}
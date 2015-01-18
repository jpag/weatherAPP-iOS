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
    var loaderDoneReason = "NA"
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    override init(frame: CGRect) {
        
        imageList = globals.shuffle(imageList)
        println(imageList)
        super.init(frame:frame)
    }
    
    func startLoader(){
        animateInNextLogo()
    }
    
    func stopAndCollapse(type:NSString) {
        loaderDoneReason = type
        keepAnimating = false
    }
    
    func loaderDone() {
        var obj = [
            "type" : loaderDoneReason
        ]
        _notificationCenter.postNotificationName(_ncEvents.loaderDoneAnimating, object: obj)
    }
    
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
    
    func removeLoader() {
        keepAnimating = false
    }

}
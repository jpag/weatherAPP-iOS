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
    var removingLoader = false
    // once the view is done animating in
    var doneAnimatingIn = false
    var stopSpinning:Bool = false
    var loaderDoneReason = "NA"
    var type = ""
    var iconView:ViewLoaderIcon!
    var iconyOffset:CGFloat = 30.0
    
    let durationIn:TimeInterval = 0.75
    let durationOut:TimeInterval = 0.35
    
    let iconWH = 50 as CGFloat
    var icony:CGFloat!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, loaderType:NSString) {
        
        imageList = globals.shuffle(imageList)
        type = loaderType as String
        
        super.init(frame:frame)
        
        // insert loader icon here:
        let iconx = (UIScreen.main.bounds.width - iconWH) / 2
        
        icony = (self.frame.height - iconWH ) / 2
        
        iconView = ViewLoaderIcon(frame:CGRect(x: iconx, y: icony, width: iconWH, height: iconWH))
        self.addSubview(iconView)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        
        if( type == globals.loaderSmall ){
            self.backgroundColor = UIColor.pastCast.white()
            //animateInOnSmall()
        }
        
        
    }
    
    func animateInOnSmall() {
        print(" ANIMATE IN")
        
        //let delay:NSTimeInterval = 0.0
        //let options = UIViewAnimationOptions.CurveEaseOut
        let destinationY:CGFloat = UIScreen.main.bounds.height * globals.halfHeight
        
        
        UIView.animate(
            withDuration: durationIn,
//            delay: delay,
//            options: options,
            animations: {
                self.frame.origin.y = destinationY
            },
            completion: nil
        )
    }
    
    func removeLoader(_ _type:NSString) {
        print(" ----- stop and collapse loader \(self.type)")
        self.loaderDoneReason = _type as String
        self.removingLoader = true
        self.animateOut(0.0)
    }
    
    func animateOut(_ delay:TimeInterval = 0.0) {
        // animate out the view first!
        
        print(" ANIMATE OUT")
        
        self.iconView.animateOut = true
        
        if( self.type == globals.loaderSmall ){
            
            // let destinationY = UIScreen.mainScreen().bounds.height
            
//            UIView.animateWithDuration(durationOut,
//                animations: {
//                    self.frame.origin.y = destinationY
//                },
//                completion: nil
//            )
            
            let delay = (1.1 * durationOut) * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time) {
                //call the method which have the steps after delay.
                self.loaderDone()
            }
        } else {
            // set a timer to give the loader icon a headstart...
            print(" - set TIMER for loaderDone() -")
            
            // .75 seconds
            let delay = 0.75 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time) {
                //call the method which have the steps after delay.
                self.loaderDone()
            }
            
            //self.loaderDone()
        }

    }
    
    func loaderDone() {
        print("------- LOADER is done dispatch event")
        self.stopSpinning = true
        
        let obj = [
            "type" : loaderDoneReason
        ]
        _notificationCenter.post(name: Notification.Name(rawValue: _ncEvents.loaderDoneAnimating), object: obj)
        // self.iconView.removeFromSuperview()
        self.removeFromSuperview();
    }
    
}

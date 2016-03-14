//
//  ViewLoaderIcon.swift
//  pastcast
//
//  Handle the rotation of the loader icon in here. vs multiple animations in the view loader
//
//  Created by JP Gary on 1/21/15.
//  Copyright (c) 2015 teamradness. All rights reserved.
//

import UIKit

class ViewLoaderIcon: UIView {
    
    var animateIn = true
    var animateOut = false
    var offsetY:CGFloat = 50
    var defaultY:CGFloat!
    var loaderUIImgVW:UIImageView!
    var numR:CGFloat = 1.0
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        let loaderIcon = UIImage(named: "loading")
        loaderUIImgVW = UIImageView(image: loaderIcon)
        loaderUIImgVW.contentMode = UIViewContentMode.ScaleAspectFit
        loaderUIImgVW.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        super.init(frame:frame)
        
        defaultY = frame.origin.y
        self.addSubview(loaderUIImgVW)
        
        spin()
    }
    
    func spin() {
        // this loops indefintely
        var duration = 0.25
        var fullRotation = CGFloat(M_PI * -2)
        let delay:NSTimeInterval = 0.0
        let options = UIViewAnimationOptions.CurveLinear
        var itIsOver = false
        
        //var iy:CGFloat = defaultY
        var ialpha:CGFloat = 1.0
        // println(" animateOut \(animateOut) animateIn \(animateIn) ")
        
        if( self.animateOut ){
            duration = 0.4
            itIsOver = true
//            iy = self.frame.origin.y + offsetY
            ialpha = 0.0
        }else if( self.animateIn ){
            duration = 0.4
            self.alpha = 0.0
//            self.frame.origin.y = defaultY + offsetY
            self.frame.origin.y = defaultY
        }
        
        fullRotation = -2.25 * numR
        numR++
        
        UIView.animateWithDuration(
            duration,
            delay: delay,
            options: options,
            animations: {
                self.loaderUIImgVW.transform = CGAffineTransformRotate(self.transform, fullRotation)
//                self.frame.origin.y = iy
                self.alpha = ialpha
            },
            completion: {(finished:Bool) in
                if( finished ){
                    self.animateIn = false
                    if( !itIsOver ){
                        self.spin()
                    }else{
                        self.remove()
                    }
                }
            }
        )
    }
    
    func remove() {
        print("removeFromSuperview() loader icon!")
        self.removeFromSuperview()
        
    }
    
}
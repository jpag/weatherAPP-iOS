//
//  ViewError.swift
//  pastcast
//
//  When there is an error display this on top.
//
//  Created by JP Gary on 10/11/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

import UIKit

class ViewError: UIView {
    
    var errorLabel:UITextView!
    var ctaLabel:UILabel!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, errorMsg:NSString) {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = UIColor.pastCast.red(alpha: 1.0)
        
        var time = 0.25
        
        var w:CGFloat = UIScreen.mainScreen().bounds.width
        var h:CGFloat = UIScreen.mainScreen().bounds.height
        var labelh:CGFloat = 50.0
        var y = labelh * 0.15
        var destY = (h * 0.25)
        var startY = (h * 0.35)
        errorLabel = UITextView( frame: CGRect(x: (w * 0.05), y: startY , width: (w * 0.9), height: (labelh * 2)) )
        errorLabel.font = UIFont.freightBigBlack(fontsize: 30.0)
        errorLabel.textColor = UIColor.pastCast.white()
        errorLabel.editable = false
        errorLabel.textAlignment = .Center
        errorLabel.backgroundColor = UIColor.clearColor()
        // errorLabel.numberOfLines = 0
        errorLabel.text = errorMsg
        
        self.addSubview(errorLabel)
        println(" errorMSg \(errorMsg)")
        
        var ctaY = errorLabel.frame.origin.y + errorLabel.frame.height + 10.0
        ctaLabel = UILabel( frame: CGRect(x:(w * 0.15), y:(ctaY - 20.0), width: (w * 0.70), height: labelh ))
        ctaLabel.font = UIFont.futuraBold()
        ctaLabel.textColor = UIColor.pastCast.red()
        ctaLabel.backgroundColor = UIColor.pastCast.white()
        ctaLabel.textAlignment = .Center
        ctaLabel.text = "Try Again?"
        ctaLabel.alpha = 0
        
        self.addSubview(ctaLabel)
        
        UIView.animateWithDuration(time,
            animations: {
                self.ctaLabel.frame.origin.y = ctaY
                self.ctaLabel.alpha = 1.0
                
                self.errorLabel.frame.origin.y = destY
                
            },
            completion: { (finished:Bool) in
                if( finished ){
                    
                }
            }
        )
        
    }
    
    func updateError(msg:NSString) {
        
        errorLabel.text = msg
    }
    

}
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

class ViewError: ViewBottomNotification {
    
    var errorLabel:UITextView!
    var ctaLabel:UILabel!
    
//    var panel:UIView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, errorMsg:NSString) {
        
        super.init(frame:frame)
        var fontsize:CGFloat = 14.0
        var w:CGFloat = panel.bounds.width
        var eIcon = UIImage(named: "error-icon")
        var iconWH:CGFloat = 20.0
        var iconx = (UIScreen.mainScreen().bounds.width - iconWH) / 2.0
        var eIconVw = UIImageView(image: eIcon )
        eIconVw.contentMode = UIViewContentMode.ScaleAspectFit
        
        var marginBetweenIconTxt:CGFloat = 10
        var fontsizeFactor:CGFloat = 1.75
        var fontHeight:CGFloat = fontsize * fontsizeFactor
        var iconY:CGFloat = (panel.bounds.height - (iconWH + fontHeight + marginBetweenIconTxt) )/2
        var textY = iconY + iconWH + marginBetweenIconTxt
        
        eIconVw.frame = CGRect(x: iconx, y: iconY, width: iconWH, height: iconWH)
        
        errorLabel = UITextView( frame: CGRect(x: (w * 0.05), y: textY , width: (w * 0.9), height: (fontHeight * 2)) )
        errorLabel.font = UIFont.futuraSerieBQBook(fontsize: fontsize)
        errorLabel.textColor = UIColor.pastCast.red()
        errorLabel.editable = false
        errorLabel.textAlignment = .Center
        errorLabel.backgroundColor = UIColor.clearColor()
        errorLabel.text = errorMsg
        
        panel.addSubview(eIconVw)
        panel.addSubview(errorLabel)
        animateIn()
        
    }
    
    
    func updateError(msg:NSString) {
        animateOut(remove: false, animateInAfter: true)
        errorLabel.text = msg
    }
    

}
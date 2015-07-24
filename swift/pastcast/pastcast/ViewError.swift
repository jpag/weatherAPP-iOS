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
//    var ctaLabel:UILabel!
    var contactSupport:UILabel!
    
//    var panel:UIView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, errorMsg:NSString, notifyUs:Bool) {
        
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
        
        var textFieldX:CGFloat = w * 0.05
        var textFieldW:CGFloat = w * 0.9
        var textFieldH:CGFloat = fontHeight * 2.0
        
        errorLabel = UITextView( frame: CGRect(x: (w * 0.05), y: textY , width: textFieldW, height: textFieldH) )
        errorLabel.font = UIFont.futuraSerieBQBook(fontsize: fontsize)
        errorLabel.textColor = UIColor.pastCast.red()
        errorLabel.editable = false
        errorLabel.textAlignment = .Center
        errorLabel.backgroundColor = UIColor.clearColor()
        errorLabel.text = errorMsg as String
        
        
        contactSupport = UILabel(frame: CGRect(
                x: textFieldX,
                y: marginBetweenIconTxt + textY + fontHeight,
                width: textFieldW,
                height: fontHeight
            ))
        
        contactSupport.textColor = UIColor.pastCast.red()
//        contactSupport.editable = false
        contactSupport.font = UIFont.futuraSerieBQBook(fontsize: fontsize)
        
        contactSupport.textAlignment = .Center
        contactSupport.text = "Notify Us"
//        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
//        let underlineAttributedString = NSAttributedString(string: "Contact Us", attributes: underlineAttribute)
//        contactSupport.attributedText = underlineAttributedString
        
        contactSupport.backgroundColor = UIColor.clearColor()
        self.contactSupport.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"tap"))
        
        panel.addSubview(eIconVw)
        panel.addSubview(errorLabel)
        panel.addSubview(contactSupport)
        
        if( notifyUs ){
            self.showContact()
        }else{
            self.hideContact()
        }
        
        animateIn()
        
    }
    
    
    func updateError(msg:NSString, notifyUs:Bool) {
        animateOut(remove: false, animateInAfter: true)
        errorLabel.text = msg as String
        
        if( notifyUs ){
            self.showContact()
        }else{
            self.hideContact()
        }
        
    }
    
    func tap() {
        println(" OPEN EMAIL! - Note that this works only on a device, not in the simulator.")
        let email = "pastcast@jpg.is"
        let url = NSURL(string: "mailto:\(email)")
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func showContact(){
        self.contactSupport.hidden = false
    }
    
    func hideContact(){
        self.contactSupport.hidden = true
    }
    

}
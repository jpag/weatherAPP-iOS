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
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, errorMsg:NSString, notifyUs:Bool) {
        
        super.init(frame:frame)
        let fontsize:CGFloat = 14.0
        let w:CGFloat = panel.bounds.width
        let eIcon = UIImage(named: "error-icon")
        let iconWH:CGFloat = 20.0
        let iconx = (UIScreen.main.bounds.width - iconWH) / 2.0
        let eIconVw = UIImageView(image: eIcon )
        eIconVw.contentMode = UIViewContentMode.scaleAspectFit
        
        let marginBetweenIconTxt:CGFloat = 10
        let fontsizeFactor:CGFloat = 1.75
        let fontHeight:CGFloat = fontsize * fontsizeFactor
        let iconY:CGFloat = (panel.bounds.height - (iconWH + fontHeight + marginBetweenIconTxt) )/2
        let textY = iconY + iconWH + marginBetweenIconTxt
        
        eIconVw.frame = CGRect(x: iconx, y: iconY, width: iconWH, height: iconWH)
        
        let textFieldX:CGFloat = w * 0.05
        let textFieldW:CGFloat = w * 0.9
        let textFieldH:CGFloat = fontHeight * 2.0
        
        errorLabel = UITextView( frame: CGRect(x: (w * 0.05), y: textY , width: textFieldW, height: textFieldH) )
        errorLabel.font = UIFont.futuraSerieBQBook(fontsize)
        errorLabel.textColor = UIColor.pastCast.red()
        errorLabel.isEditable = false
        errorLabel.textAlignment = .center
        errorLabel.backgroundColor = UIColor.clear
        errorLabel.text = errorMsg as String
        
        
        contactSupport = UILabel(frame: CGRect(
                x: textFieldX,
                y: marginBetweenIconTxt + textY + fontHeight,
                width: textFieldW,
                height: fontHeight
            ))
        
        contactSupport.textColor = UIColor.pastCast.red()
//        contactSupport.editable = false
        contactSupport.font = UIFont.futuraSerieBQBook(fontsize)
        
        contactSupport.textAlignment = .center
        contactSupport.text = "Notify Us"
//        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
//        let underlineAttributedString = NSAttributedString(string: "Contact Us", attributes: underlineAttribute)
//        contactSupport.attributedText = underlineAttributedString
        
        contactSupport.backgroundColor = UIColor.clear
        self.contactSupport.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(ViewError.tap)))
        
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
    
    
    func updateError(_ msg:NSString, notifyUs:Bool) {
        animateOut(false, animateInAfter: true)
        errorLabel.text = msg as String
        
        if( notifyUs ){
            self.showContact()
        }else{
            self.hideContact()
        }
        
    }
    
    func tap() {
        print(" OPEN EMAIL! - Note that this works only on a device, not in the simulator.")
        let email = "pastcast@jpg.is"
        let url = URL(string: "mailto:\(email)")
        
        UIApplication.shared.openURL(url!)
    }
    
    func showContact(){
        self.contactSupport.isHidden = false
    }
    
    func hideContact(){
        self.contactSupport.isHidden = true
    }
    

}

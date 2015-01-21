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
    
    var panel:UIView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, errorMsg:NSString) {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.darkGray(alpha: 0.1)
        
        var time = 0.25
        
        var w:CGFloat = UIScreen.mainScreen().bounds.width
        var h:CGFloat = UIScreen.mainScreen().bounds.height
        
        // has icon?
        
        var pheight = UIScreen.mainScreen().bounds.height * (1.0 - globals.halfHeight)
        var py = UIScreen.mainScreen().bounds.height
        
        var labelTop = pheight * 0.2
        var labelh:CGFloat = 50.0
        
        panel = UIView(frame: CGRect(x:0,y:py,width:w, height: pheight))
        panel.backgroundColor = UIColor.pastCast.white()
        
        self.addSubview(panel)
        
        var eIcon = UIImage(named: "error-icon")
        var iconWH:CGFloat = 20.0
        var iconx = (UIScreen.mainScreen().bounds.width - iconWH) / 2.0
            
        var eView = UIImageView(image: eIcon )
        eView.contentMode = UIViewContentMode.ScaleAspectFit
        eView.frame = CGRect(x: iconx, y: labelTop, width: iconWH, height: iconWH)
        
        panel.addSubview(eView)
        
        errorLabel = UITextView( frame: CGRect(x: (w * 0.05), y: labelTop + iconWH + 5 , width: (w * 0.9), height: (labelh * 2)) )
        errorLabel.font = UIFont.futuraSerieBQBook(fontsize: 14.0)
        errorLabel.textColor = UIColor.pastCast.red()
        errorLabel.editable = false
        errorLabel.textAlignment = .Center
        errorLabel.backgroundColor = UIColor.clearColor()
        errorLabel.text = errorMsg
        
        panel.addSubview(errorLabel)
        
        animateIn()
    
    }
    
    func animateIn() {
        var pfinalY = UIScreen.mainScreen().bounds.height * globals.halfHeight

        UIView.animateWithDuration(0.35,
            
            animations: {
                self.panel!.frame.origin.y = pfinalY
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
//
//  ViewBottomNotification.swift
//  pastcast
//
//  Bottom notification is used for both error messages and loading screens.
//  it slides up into view and takes up the same amount of the bottom of the screen as the other visible block does.
//
//  Created by JP Gary on 1/21/15.
//  Copyright (c) 2015 teamradness. All rights reserved.
//

import UIKit

class ViewBottomNotification: UIView {
    
    var panel:UIView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
    
        super.init(frame:frame)
    
        self.backgroundColor = UIColor.darkGray(alpha: 0.1)
    
        var time = 0.25
    
        var w:CGFloat = UIScreen.mainScreen().bounds.width
        var h:CGFloat = UIScreen.mainScreen().bounds.height
    
        // has icon?
    
        var pheight = UIScreen.mainScreen().bounds.height * (1.0 - globals.halfHeight)
        var py = UIScreen.mainScreen().bounds.height
    
        var labelh:CGFloat = 50.0
    
        panel = UIView(frame: CGRect(x:0,y:py,width:w, height: pheight))
        panel.backgroundColor = UIColor.pastCast.white()
    
        self.addSubview(panel)
    }
    
    func animateIn() {
        var visibleY = UIScreen.mainScreen().bounds.height * globals.halfHeight
        
        UIView.animateWithDuration(0.35,
            
            animations: {
                self.panel!.frame.origin.y = visibleY
            },
            
            completion: { (finished:Bool) in
                if( finished ){
                    
                }
            }
        )
    }
    
    func animateOut(remove:Bool = false, animateInAfter:Bool = false ) {
        var hideY = UIScreen.mainScreen().bounds.height
        
        UIView.animateWithDuration(0.35,
            
            animations: {
                self.panel!.frame.origin.y = hideY
            },
            
            completion: { (finished:Bool) in
                if( finished ){
                    // remove
                    if( remove ){
                        
                    }else if( animateInAfter ){
                        self.animateIn()
                    }
                }
            }
        )
    }
    
    func remove() {
        animateOut(remove: true)
    }
    
}

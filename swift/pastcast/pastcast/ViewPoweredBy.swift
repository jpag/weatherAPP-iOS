//
//  ViewPoweredBy.swift
//  pastcast
//
//  Created by JP Gary on 10/11/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

import UIKit

class ViewPoweredBy: UIView {

    let msg = "Powered by Forecast"
    var txtVw:UITextView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    override init() {
        var w = UIScreen.mainScreen().bounds.width
        var h = UIScreen.mainScreen().bounds.height
        
        var frame = CGRect(x: 0, y:0, width: w, height: h)
        
        super.init(frame:frame)
        
        txtVw = UITextView( frame: CGRect(x: 0, y: (h * 0.07) , width: w, height: 25.0) )
        txtVw.font = UIFont.freightBigBlack(fontsize: 16.0)
        txtVw.textColor = UIColor.darkGray(alpha: 0.5)
        txtVw.backgroundColor = UIColor.clearColor()
        txtVw.editable = false
        txtVw.textAlignment = .Center
        txtVw.text = msg
        
        self.backgroundColor = UIColor.pastCast.white()
        self.addSubview(txtVw)
        
        txtVw.alpha = 0
        
        _notificationCenter.addObserverForName(_ncEvents.showPoweredBy, object: nil, queue: nil, usingBlock: showMsg )
        _notificationCenter.addObserverForName(_ncEvents.hidePoweredBy, object: nil, queue: nil, usingBlock: hideMsg )
    }
    
    func showMsg(obj:NSNotification!) {
        
        txtVw.alpha = 1.0

    }
    
    func hideMsg(obj:NSNotification!) {
        txtVw.alpha = 0
    }
    
}
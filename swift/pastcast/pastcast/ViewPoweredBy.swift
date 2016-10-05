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
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init() {
        
        print(" powered by ")
        
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        let frame = CGRect(x: 0, y:0, width: w, height: h)
        
        super.init(frame:frame)
        
        txtVw = UITextView( frame: CGRect(x: 0, y: 15 , width: w, height: 25.0) )
        txtVw.font = UIFont.freightBigBlack(16.0)
        txtVw.textColor = UIColor.darkGray(0.5)
        txtVw.backgroundColor = UIColor.clear
        txtVw.isEditable = false
        txtVw.textAlignment = .center
        txtVw.text = msg
        
        self.backgroundColor = UIColor.clear
        self.addSubview(txtVw)
        
//        txtVw.alpha = 0
        
        _notificationCenter.addObserver(forName: _ncEvents.showPoweredBy, object: nil, queue: nil, using: showMsg )
        _notificationCenter.addObserver(forName: _ncEvents.hidePoweredBy, object: nil, queue: nil, using: hideMsg )
    }
    
    func showMsg(_ obj:Notification!) {
        
        txtVw.alpha = 1.0

    }
    
    func hideMsg(_ obj:Notification!) {
        txtVw.alpha = 0
    }
    
}

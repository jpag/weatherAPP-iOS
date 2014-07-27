//
//  ViewTempBlock.swift
//  pastcast
//
//  This is one block for the temperature 
//  it takes two states either open or collapsed
//
//  Created by JP Gary on 7/26/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

import UIKit

class ViewTempBlock: UIView {
    
    var pos:Int!
    var temps:NSArray!
    var state:NSString!
    var statePercent:CGFloat = 0.00
    
    var padding:CGFloat         = 10.0
    var paddingSide:CGFloat     = 10.0
    var paddingTop:CGFloat      = 10.0
    var locationHeight:CGFloat  = 28.0
    var timeHeight:CGFloat      = 20.0
    
    
    var timeTop:CGFloat         = 0
    var locaTop:CGFloat         = 0
    
    var locationLabel:UILabel!
    var timeLabel:UILabel!
    
    var temperatureLabel:UILabel!
    var tempTypeLabel:UILabel!
    
    var tempLabelHeight:CGFloat = 30.0
    var tempTypeLabelHeight:CGFloat = 18.0
    
    
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, _temps:NSArray, _pos:Int, _state:NSString) {
        println("\n\n")
        
        temps = _temps
        pos = _pos
        state = _state
        
        var w = UIScreen.mainScreen().bounds.width
        
        locationLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height: locationHeight) )
        timeLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height:timeHeight) )
        
        temperatureLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height: tempLabelHeight))
        tempTypeLabel   = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: tempTypeLabelHeight))
        
        super.init(frame:frame)
        
        // println( " pos \(pos) frame \(frame)")
        
        var maskLayer = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        maskLayer.backgroundColor = UIColor.blackColor()
        self.maskView = maskLayer
        
        
        locationLabel.font = UIFont.freightBigBlack(fontsize: locationHeight)
        locationLabel.textColor = UIColor.pastCast.white()
        
        timeLabel.font = UIFont.freightBoldItalic(fontsize: timeHeight)
        timeLabel.textColor = UIColor.pastCast.white()
        
        temperatureLabel.font = UIFont.futuraBook(fontsize: tempLabelHeight)
        temperatureLabel.textColor = UIColor.pastCast.white()
        
        tempTypeLabel.font = UIFont.futuraBook(fontsize: tempTypeLabelHeight)
        tempTypeLabel.textColor = UIColor.pastCast.white()
        
        self.addSubview( locationLabel )
        self.addSubview( timeLabel )
        self.addSubview( temperatureLabel )
        self.addSubview( tempTypeLabel )
        
        update(_temps)
    }
    
    
    func update(tempBlock:NSArray) {
        // update 
        println( "\n---- Temp block update ---- \(tempBlock[0])")
        
        temps = tempBlock
        
        if( Int(temps[0] as NSNumber) > Int(temps[1] as NSNumber) ){
            
            println( " it is warmer")
            self.backgroundColor = UIColor.pastCast.red(alpha: 1.0)
            
        }else{
            println( " it is colder" )
            self.backgroundColor = UIColor.pastCast.blue(alpha: 1.0)
        }
        
        var tempType = "F"
        if( pastCastModel.isCelsius ){
            tempType = "C"
        }
        var temp = Int(temps[0] as NSNumber)
        temperatureLabel.text = String(temp) + "°"
        tempTypeLabel.text = tempType
        tempTypeLabel.sizeToFit()
        temperatureLabel.sizeToFit()
        
        // update labels:
        locationLabel.text = pastCastModel.locationName
        var dateStr = "N/A"
        var date = NSDate()
        if( pos == 1 ){
            date = date.dateByAddingTimeInterval( -60 * 60 * 24 )
        }
        var formater = NSDateFormatter()
        formater.dateFormat = "EEEE MMMM d"
        dateStr = formater.stringFromDate(date)
        timeLabel.text = dateStr
        
        updatePositions()
    }
    
    func updatePositions() {
        
        // temperature / temperature label
        var labelY = frame.height/2
        if( pos == 1 ){
            labelY = ( (UIScreen.mainScreen().bounds.height * 0.25) - temperatureLabel.frame.height) / 2
        }
        temperatureLabel.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: labelY )
        tempTypeLabel.frame.origin = CGPoint(x: temperatureLabel.frame.origin.x + temperatureLabel.frame.width, y: labelY - padding)
        
        
        // Location and date stamp
//        if pos == 1 {
//            locaTop = -(locationHeight + paddingTop)
//            timeTop = paddingTop
//        }else{
//            locaTop = paddingTop
//            timeTop = (paddingTop*2)+locationHeight
//        }
        
        let locRange = (min:-(locationHeight + paddingTop), med: paddingTop, max: self.bounds.height * 0.6 )
        let locAlphaRange = (min:CGFloat(0), med:CGFloat(1.0), max:CGFloat(0))
        let timeRange = (min: paddingTop , med: paddingTop*2 + locationHeight, max: self.bounds.height * 0.6 + (locationHeight + paddingTop * 1.25)   )
        
        var locpercent = statePercent
        if( locpercent < 0.33 && pos == 0 ){
            locpercent = 0.33
        }
        var timeLabelTop = locaTop + locationHeight + padding
        var locAlpha:CGFloat = 1.0
        
        if( locpercent < 0.33 ) {
            var per = (locpercent / 0.33)
            locaTop = recalFromRange(locRange.min, max: locRange.med, percent: per )
            locAlpha = recalFromRange( locAlphaRange.min, max: locAlphaRange.med, percent: per)
            timeLabelTop = recalFromRange(timeRange.min, max: timeRange.med, percent: per )
        }else if( locpercent < 0.66 ){
            var per = ( (locpercent - 0.33) / 0.33)
            locaTop = recalFromRange(locRange.med, max: locRange.max, percent: per )
            locAlpha = recalFromRange(locAlphaRange.med, max: locAlphaRange.max, percent: per)
            timeLabelTop = recalFromRange(timeRange.med, max: timeRange.max, percent: per )
            
        }else{
            locaTop     = locRange.max
            timeLabelTop = timeRange.max
            locAlpha    = locAlphaRange.max
        }
        
        
        println(" ------ \( pos) ----- \(locpercent) " )
        println( locRange )
        println( locaTop )
        
        locationLabel.frame.origin.y = locaTop
        locationLabel.frame.origin.x = padding
        timeLabel.frame.origin.y = timeLabelTop
        timeLabel.frame.origin.x = padding
        
        //locationLabel.alpha = CGFloat(locAlpha)
        
    }
    
    
    func recalFromRange(min:CGFloat,max:CGFloat, percent:CGFloat ) -> CGFloat {
        
        return min + (abs( min - max) * percent)
    }
    
    func updateState(percent:CGFloat) {
        
        if( pos == 0 ) {
            statePercent = (percent * 0.33) + 0.33
        }else if( pos == 1 ){
            statePercent = (percent * 0.33)
        }
        
        // this will then force a draw/update position of labels etc.
        println( " pos \(pos) startpercent \(statePercent) ")
        
        updatePositions()
    }
    
    

}
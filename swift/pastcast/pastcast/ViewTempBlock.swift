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
    var statePercent:CGFloat    = 0.00
    
    var padding:CGFloat         = 10.0
    var paddingSide:CGFloat     = 20.0
    var paddingTop:CGFloat      = 20.0
    var paddingTopTime:CGFloat  = 19.0
    var locationHeight:CGFloat  = 28.0
    var timeHeight:CGFloat      = 20.0
    
    var timeTop:CGFloat         = 0
    var locaTop:CGFloat         = 0
    
    var locationLabel:UILabel!
    var timeLabel:UILabel!
    
    
    // container to hold temperature, icon, and temp type
    var tempContainer:UIView!
    var temperatureLabel:UILabel!
    var tempTypeLabel:UILabel!
    var tempLabelHeight:CGFloat     = 30.0
    var tempTypeLabelHeight:CGFloat = 18.0
    var iconBlock:UIView!
    
    var weatherCode:NSString = "sunny";
    
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, _temps:NSArray,_weathercode:NSString, _pos:Int, _state:NSString) {
        // println("\n\n")
        
        temps = _temps
        pos = _pos
        state = _state
        
        var w = UIScreen.mainScreen().bounds.width
        
        locationLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height: locationHeight) )
        timeLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height:timeHeight) )
        
        temperatureLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height: tempLabelHeight))
        tempTypeLabel   = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: tempTypeLabelHeight))
        
        tempContainer = UIView(frame: CGRect(x:0, y:0, width:w, height: (tempLabelHeight + tempTypeLabelHeight) ) )
        
        
        super.init(frame:frame)
        
        // type of weather :
        var iconWH:CGFloat = globals.iconWH()
        
        weatherCode = _weathercode
        var weatherIcon = UIImage(named: weatherCodes.getCodeFromString(weatherCode))
        
        var weatherIconView = UIImageView(image: weatherIcon )
        weatherIconView.contentMode = UIViewContentMode.ScaleAspectFit
        weatherIconView.frame = CGRect(x: 0, y: 0, width: iconWH, height: iconWH)
        
        iconBlock = UIView(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        iconBlock.addSubview(weatherIconView)
        
        var iconMaskLayer = UIView(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        iconMaskLayer.backgroundColor = UIColor.blackColor()
        iconBlock.maskView = iconMaskLayer
        
        var maskLayer = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        maskLayer.backgroundColor = UIColor.blackColor()
        self.maskView = maskLayer
        
        
        locationLabel.font = UIFont.freightBigBlack(fontsize: locationHeight)
        locationLabel.textColor = UIColor.pastCast.white()
        
        timeLabel.font = UIFont.freightBoldItalic(fontsize: timeHeight)
        timeLabel.textColor = UIColor.pastCast.white()
        
        temperatureLabel.font = UIFont.futuraSerieBQBook(fontsize: tempLabelHeight)
        temperatureLabel.textColor = UIColor.pastCast.white()
        
        tempTypeLabel.font = UIFont.futuraSerieBQBook(fontsize: tempTypeLabelHeight)
        //tempTypeLabel.font = UIFont.freightBoldItalic(fontsize: tempTypeLabelHeight)
        tempTypeLabel.textColor = UIColor.pastCast.white()
        
        self.addSubview( locationLabel )
        self.addSubview( timeLabel )
        
        tempContainer.addSubview( temperatureLabel )
        tempContainer.addSubview( tempTypeLabel )
        tempContainer.addSubview( iconBlock )
        self.addSubview(tempContainer)
        
        update(_temps)
    }
    
    
    func update(tempBlock:NSArray) {
        // update 
        // println( "\n---- Temp block update ---- \(tempBlock[0])")
        
        temps = tempBlock
        
        if( Int(temps[0] as NSNumber) > Int(temps[1] as NSNumber) ){
            
            println( " it is warmer")
            self.backgroundColor = UIColor.pastCast.red(alpha: 1.0)
            
        }else if( Int(temps[0] as NSNumber) < Int(temps[1] as NSNumber) ){
            println( " it is colder" )
            self.backgroundColor = UIColor.pastCast.blue(alpha: 1.0)
        }else {
            println(" same temps")
            self.backgroundColor = UIColor.pastCast.red(alpha: 1.0)
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
        let third:CGFloat = 0.33
        let twoThirds:CGFloat = 0.66
        
        // 49.5 ? // for use on icon collapsing before opening on side.
        // two step effect between one state.
        let midWayBetweenThirds:CGFloat = (third + (third/2))
        
        var locpercent = statePercent
        if( locpercent < third && pos == 0 ){
            // make sure the first block does not look funny on pull to refresh:
            locpercent = third
        }
        
        let tempYRange = (
            min : CGFloat( ((UIScreen.mainScreen().bounds.height * 0.3) - temperatureLabel.frame.height) / 2 ),
            med : CGFloat( frame.height / 2 ),
            max : CGFloat( frame.height * 0.83)
        )
        
        let iconRangeY = (
            min : CGFloat( paddingTop + locationHeight ),
            med : CGFloat( paddingTop + locationHeight ),
            max : CGFloat( 0 )
        )
        
        let iconRangeHW = (
            zero    : CGFloat( 0 ),
            third   : CGFloat( globals.iconWH() ),
            half    : CGFloat(0),
            twoThirds : CGFloat( globals.iconWH() )
        )
        
        let iconRangeX = (
            min : CGFloat(),
            med : CGFloat(),
            max : CGFloat()
        )
        
        let locRange = (
            min:-(locationHeight + paddingTop),
            med: paddingTop,
            max: self.bounds.height * 0.6
        )
        
        let timeRange = (
            min: paddingTopTime * 1.25,
            med: paddingTopTime + locationHeight,
            max: self.bounds.height * 0.6 + (locationHeight + paddingTopTime)
        )
        
        var per:CGFloat!
        var tempYPos:CGFloat!
        var iconY: CGFloat!
        var newiconHeight:CGFloat!
        var newiconWidth:CGFloat!
        var tempContainerX:CGFloat = UIScreen.mainScreen().bounds.width/2
        var timeLabelTop = locaTop + locationHeight + padding

        
        if( locpercent < third ) {
            per = (locpercent / third)
            locaTop = recalFromRange(locRange.min, max: locRange.med, percent: per )
            timeLabelTop = recalFromRange(timeRange.min, max: timeRange.med, percent: per )
            tempYPos = recalFromRange(tempYRange.min, max: tempYRange.med, percent: per)
            
            
        }else if( locpercent < twoThirds ){
            per = ( (locpercent - third) / third)
            locaTop = recalFromRange(locRange.med, max: locRange.max, percent: per )
            timeLabelTop = recalFromRange(timeRange.med, max: timeRange.max, percent: per )
            tempYPos = recalFromRange(tempYRange.med, max:tempYRange.max, percent: per)
            
        }else{
            locaTop     = locRange.max
            timeLabelTop = timeRange.max
            tempYPos = tempYRange.max
        }
        
        var tempContMinY = timeLabelTop + locationHeight
        if( tempYPos <= tempContMinY ){
            tempYPos = tempContMinY
        }
        
        locationLabel.frame.origin.y = locaTop
        locationLabel.frame.origin.x = paddingSide
        timeLabel.frame.origin.y = timeLabelTop
        timeLabel.frame.origin.x = paddingSide
        
        var iconX:CGFloat!
        
        if( locpercent < third ){
            per = (locpercent) / third
            
            newiconHeight = recalFromRange(iconRangeHW.zero, max: iconRangeHW.third, percent: per)
            newiconWidth = iconRangeHW.third
            iconY = recalFromRange(iconRangeY.min, max: iconRangeY.med, percent: per)
            iconX = temperatureLabel.frame.origin.x
            
        }else if( locpercent < midWayBetweenThirds ){
            // close the icon up
            per = (locpercent - third) / (midWayBetweenThirds - third)
            //println(" percent \(per) ----- ")
            newiconHeight = recalFromRange(iconRangeHW.third, max: iconRangeHW.half, percent: per)
            newiconWidth = iconRangeHW.third
            iconX = temperatureLabel.frame.origin.x
            iconY = iconRangeY.min
            
        }else if( locpercent < twoThirds ) {
            // open the icon on the side and shift the container over left
            per = (locpercent - midWayBetweenThirds) / (midWayBetweenThirds - third)
            
            newiconHeight = iconRangeHW.twoThirds
            newiconWidth = recalFromRange(iconRangeHW.half, max: iconRangeHW.twoThirds, percent: per)
            
            iconY = iconRangeY.max
            iconX = tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width + padding
            
            //recalFromRange(temperatureLabel.frame.origin.x , max: tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width + padding, percent: per)
            
            tempContainerX = recalFromRange(
                tempContainerX,
                max: UIScreen.mainScreen().bounds.width/2 - (tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width ),
                percent: per
            )
            
        }else {
            // hitting max
            newiconHeight = iconRangeHW.twoThirds
            newiconWidth = iconRangeHW.twoThirds
            
            iconX = tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width + padding
            iconY = iconRangeY.max
            
            tempContainerX = (UIScreen.mainScreen().bounds.width/2 - (tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width) )
        }
        
        tempContainer.frame.origin = CGPoint(x: tempContainerX, y: tempYPos)
        temperatureLabel.frame.origin = CGPoint(x: -(temperatureLabel.frame.width/2), y: 0 )
        tempTypeLabel.frame.origin = CGPoint(x: temperatureLabel.frame.width/2, y: 10.0)
        
        iconBlock.frame.origin.y = iconY
        iconBlock.frame.origin.x = iconX
        
        iconBlock.maskView?.frame = CGRect(x: 0, y: 0, width: newiconWidth, height: newiconHeight)

    }
    
    func recalFromRange(min:CGFloat,max:CGFloat, percent:CGFloat ) -> CGFloat {
        if( max < min){
            return min - (abs( max - min) * percent)
        }else{
            return min + (abs( min - max) * percent)
        }
    }
    
    func updateState(percent:CGFloat) {
        
        if( pos == 0 ) {
            statePercent = (percent * 0.33) + 0.33
        }else if( pos == 1 ){
            statePercent = (percent * 0.33)
        }
        
        // this will then force a draw/update position of labels etc.
        //println( " pos \(pos) startpercent \(statePercent) ")
        
        updatePositions()
    }
    
    

}
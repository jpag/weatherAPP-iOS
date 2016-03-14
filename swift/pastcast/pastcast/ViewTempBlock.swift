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
    var paddingTopIcon:CGFloat  = 40.0
    var paddingSideIcon:CGFloat = 40.0
    var paddingTop:CGFloat      = 20.0
    var paddingTopTime:CGFloat  = 19.0
    var locationHeight:CGFloat  = 28.0
    var timeHeight:CGFloat      = 20.0
    
    var timeTop:CGFloat         = 0
    var locaTop:CGFloat         = 0
    
    // labels for top left corner
    var locationLabel:UILabel!
    var timeLabel:UILabel!
    
    // container to hold temperatureLabel, iconBlock, and tempTypeLabel
    var tempContainer:UIView!
    // the temperature value is placed in here
    var temperatureLabel:UILabel!
    // degrees in C or F
    var tempTypeLabel:UILabel!
    // Icon block holds the weather icon and has a mask to crop out the icon
    var iconBlock:UIView!
    // The image view
    var weatherIconView:UIImageView!
    // the line to divide between the icon and the temperature
    var dividerLine:UIImageView!
    var dividerLineStroke:CGFloat = 1.0
    
    var tempLabelHeight:CGFloat     = 30.0
    var tempTypeLabelHeight:CGFloat = 18.0
    var weatherCode:NSString = "sunny";
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    // temps[0] is always 'this' temp. temp[1] is the one to compare to.
    init(frame: CGRect, _temps:NSArray,_weathercode:NSString, _pos:Int, _state:NSString) {
        // println("\n\n")
        
        temps = _temps
        pos = _pos
        state = _state
        
        let w = UIScreen.mainScreen().bounds.width
        
        locationLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height: locationHeight) )
        timeLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height:timeHeight) )
        
        temperatureLabel = UILabel( frame: CGRect(x: 0, y: 0, width: w, height: tempLabelHeight))
        tempTypeLabel   = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: tempTypeLabelHeight))
        
        tempContainer = UIView(frame: CGRect(x:0, y:0, width:w, height: (tempLabelHeight + tempTypeLabelHeight) ) )
        
        super.init(frame:frame)
        
        // type of weather :
        let iconWH:CGFloat = globals.iconWH()
        
        weatherCode = _weathercode
        let weatherIcon = UIImage(named: weatherCodes.getCodeFromString(weatherCode) as String)
        
        weatherIconView = UIImageView(image: weatherIcon )
        weatherIconView.contentMode = UIViewContentMode.ScaleAspectFit
        weatherIconView.frame = CGRect(x: 0, y: 0, width: iconWH, height: iconWH)
        
        //weatherIconView.backgroundColor = UIColor.pastCast.white(alpha: 0.15)
        
        iconBlock = UIView(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        iconBlock.addSubview(weatherIconView)
        //iconBlock.backgroundColor = UIColor.pastCast.white(alpha: 0.1)
        
        let iconMaskLayer = UIView(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        iconMaskLayer.backgroundColor = UIColor.blackColor()
        iconBlock.maskView = iconMaskLayer
        
        let maskLayer = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        maskLayer.backgroundColor = UIColor.blackColor()
        self.maskView = maskLayer
        
        
        locationLabel.font = UIFont.freightBigBlack(locationHeight)
        locationLabel.textColor = UIColor.pastCast.white()
        
        timeLabel.font = UIFont.freightBoldItalic(timeHeight)
        timeLabel.textColor = UIColor.pastCast.white()
        
        temperatureLabel.font = UIFont.futuraSerieBQBook(tempLabelHeight)
        temperatureLabel.textColor = UIColor.pastCast.white()
        
        tempTypeLabel.font = UIFont.futuraSerieBQBook(tempTypeLabelHeight)
        tempTypeLabel.textColor = UIColor.pastCast.white()
        
        // create line divider :
        dividerLine = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: dividerLineStroke))
        dividerLine.backgroundColor = UIColor.pastCast.white(1.0)
        
        self.addSubview( locationLabel )
        self.addSubview( timeLabel )
        
        tempContainer.addSubview( temperatureLabel )
        tempContainer.addSubview( tempTypeLabel )
        tempContainer.addSubview( dividerLine )
        tempContainer.addSubview( iconBlock )
        self.addSubview(tempContainer)
        
        update(_temps)
    }
    
    
    func update(tempBlock:NSArray) {
        // update 
        // println( "\n---- Temp block update ---- \(tempBlock[0])")
        
        temps = tempBlock
        
        if( Int(temps[0] as! NSNumber) > Int(temps[1] as! NSNumber) ){
            
            print( " it is warmer")
            self.backgroundColor = UIColor.pastCast.red(1.0)
            
        }else if( Int(temps[0] as! NSNumber) < Int(temps[1] as! NSNumber) ){
            print( " it is colder" )
            self.backgroundColor = UIColor.pastCast.blue(1.0)
        }else {
            print(" same temps")
            self.backgroundColor = UIColor.pastCast.red(1.0)
        }
        
        var tempType = "F"
        if( pastCastModel.isCelsius ){
            tempType = "C"
        }
        let temp = Int(temps[0] as! NSNumber)
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
        let formater = NSDateFormatter()
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
            med : CGFloat( frame.height / 2.2 ),
            max : CGFloat( frame.height * 0.83)
        )
        
        let iconRangeY = (
            min : CGFloat( dividerLineStroke + paddingTopIcon + locationHeight ),
            med : CGFloat( dividerLineStroke + paddingTopIcon + locationHeight ),
            max : CGFloat( -globals.iconWH() * 0.1 )
        )
        
        let iconRangeHW = (
            zero    : CGFloat( 0 ),
            third   : CGFloat( globals.iconWH() ),
            half    : CGFloat(0),
            twoThirds : CGFloat( globals.iconWH() )
        )
        
//        let iconRangeX = (
//            min : CGFloat(),
//            med : CGFloat(),
//            max : CGFloat()
//        )
        
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
        
        var dividerX:CGFloat!
        var dividerY:CGFloat!
        var dividerW:CGFloat!
        var dividerH:CGFloat!
        
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
        
        let tempContMinY = timeLabelTop + locationHeight
        if( tempYPos <= tempContMinY ){
            tempYPos = tempContMinY
        }
        
        locationLabel.frame.origin.y = locaTop
        locationLabel.frame.origin.x = paddingSide
        timeLabel.frame.origin.y = timeLabelTop
        timeLabel.frame.origin.x = paddingSide
        
        var iconX:CGFloat!
        let percentOfIconHeightForDivider = (height:CGFloat(0.8), width:CGFloat(0.9))
        var dividerAlpha:CGFloat = 1.0
        let dividerYFactor:CGFloat = 2.25
        
        let iconWH:CGFloat = globals.iconWH()
        var iconImagePos:(x:CGFloat,y:CGFloat) = (x:0, y:0)
        
        if( locpercent < third ){
            // fully collapsed just temp number no icon
            per = (locpercent) / third
            newiconHeight = recalFromRange(iconRangeHW.zero, max: iconRangeHW.third, percent: per)
            newiconWidth = iconRangeHW.third
            iconY = recalFromRange(iconRangeY.min, max: iconRangeY.med, percent: per)
            iconX = temperatureLabel.frame.origin.x
            
            dividerAlpha = per
            dividerW = (newiconWidth * percentOfIconHeightForDivider.width) * per
            dividerH = dividerLineStroke
            dividerX = iconX + (newiconWidth - dividerW)/2
            dividerY = iconY - ((1) * (paddingTopIcon/dividerYFactor) + dividerLineStroke)
            
            // icon Y is at the desired point.
            // dont bring them apart until 75% of per
            
            let adjustedID = self.subsetAdjust(iconY, dividerCord: dividerY, per: per, subsetRangePer: 0.8)
            iconY = adjustedID.icon
            dividerY = adjustedID.divider
            
            
            iconImagePos.y = (1 - per) * -(iconWH * 2)
            
        }else if( locpercent < midWayBetweenThirds ){
            // open state
            per = (locpercent - third) / (midWayBetweenThirds - third)
            newiconHeight = recalFromRange(iconRangeHW.third, max: iconRangeHW.half, percent: per)
            newiconWidth = iconRangeHW.third
            iconX = temperatureLabel.frame.origin.x
            iconY = iconRangeY.min
            
            dividerW = (newiconWidth * percentOfIconHeightForDivider.width) * (1 - per)
            dividerH = dividerLineStroke
            dividerX = iconX + (newiconWidth - dividerW)/2
            
            dividerY = iconY - ((1) * ((paddingTopIcon/dividerYFactor) + dividerLineStroke))
            
            let adjustedID = self.subsetAdjust(iconY, dividerCord: dividerY, per: 1 - per, subsetRangePer: 0.85)
            
            iconY = adjustedID.icon
            dividerY = adjustedID.divider
            
            dividerAlpha = 1 - per;
            iconImagePos.y = (per) * -(iconWH * 1)
        }else if( locpercent < twoThirds ) {
            // open the icon on the side and shift the container over left
            per = (locpercent - midWayBetweenThirds) / (midWayBetweenThirds - third)
            newiconHeight = iconRangeHW.twoThirds
            newiconWidth = recalFromRange(iconRangeHW.half, max: iconRangeHW.twoThirds, percent: per)
            iconY = iconRangeY.max
            iconX = tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width + paddingSideIcon
            
            tempContainerX = recalFromRange(
                tempContainerX,
                max: UIScreen.mainScreen().bounds.width/2 - (tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width ),
                percent: per
            )
            
            dividerW = dividerLineStroke
            dividerH = (newiconHeight * percentOfIconHeightForDivider.height) * per
            dividerX = iconX - (paddingSideIcon/2)
            
            let adjustedID = self.subsetAdjust(iconX, dividerCord: dividerX, per: per, subsetRangePer: 0.8)
            iconX = adjustedID.icon
            dividerX = adjustedID.divider
            
            dividerY = iconY + (newiconHeight - dividerH)/2
            dividerAlpha = per;
            
            iconImagePos.x = (1 - per) * -(iconWH)
        }else {
            // hitting temp and icon side by side.
            newiconHeight = iconRangeHW.twoThirds
            newiconWidth = iconRangeHW.twoThirds
            iconX = tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width + paddingSideIcon
            iconY = iconRangeY.max
            tempContainerX = (UIScreen.mainScreen().bounds.width/2 - (tempTypeLabel.frame.origin.x + tempTypeLabel.frame.width) )
            
            dividerW = dividerLineStroke
            dividerH = newiconHeight * percentOfIconHeightForDivider.height
            dividerX = iconX - (paddingSideIcon/2)
            
            dividerY = iconY + (newiconHeight - dividerH)/2
            
        }
        
        tempContainer.frame.origin = CGPoint(x: tempContainerX, y: tempYPos)
        temperatureLabel.frame.origin = CGPoint(x: -(temperatureLabel.frame.width/2), y: 0 )
        tempTypeLabel.frame.origin = CGPoint(x: temperatureLabel.frame.width/2, y: 10.0)
        
        iconBlock.frame.origin.y = iconY
        iconBlock.frame.origin.x = iconX
        iconBlock.maskView?.frame = CGRect(x: 0, y: 0, width: newiconWidth, height: newiconHeight)
        
        weatherIconView.frame = CGRect(x:iconImagePos.x, y:iconImagePos.y, width:iconWH, height: iconWH )
            
        
        dividerLine.frame = CGRect(x: dividerX, y: dividerY, width: dividerW, height: dividerH)
        dividerLine.alpha = dividerAlpha
    }
    
    func recalFromRange(min:CGFloat,max:CGFloat, percent:CGFloat ) -> CGFloat {
        if( max < min){
            return min - (abs( max - min) * percent)
        }else{
            return min + (abs( min - max) * percent)
        }
    }
    
    // adjust positioning of the icon and line to a further subset percent
    func subsetAdjust(iconCord:CGFloat, dividerCord:CGFloat, per:CGFloat, subsetRangePer:CGFloat = 0.80 )
        -> (icon:CGFloat, divider:CGFloat) {

        var rIconCord:CGFloat = iconCord
        var rDividerCord:CGFloat = dividerCord
        
        // icon Y is at the desired point.
        // dont bring them apart until 75% of per
        let midwayPt:CGFloat = rIconCord - (rIconCord - rDividerCord)/2
        if( per < subsetRangePer ){
            // keep them together:
            rIconCord = midwayPt
            rDividerCord = rIconCord
        }else{
            // else increment them towards their destinations:
            let p:CGFloat = (per - subsetRangePer) / (1 - subsetRangePer)
            
            rDividerCord = dividerCord - (dividerCord - midwayPt) * (1 - p)
            rIconCord = iconCord - (iconCord - midwayPt) * (1 - p)
        }
        
        return (icon:rIconCord, divider:rDividerCord)
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
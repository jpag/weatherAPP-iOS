//
//  _Extensions.swift
//  pastcast
//
//  Created by JP Gary on 7/25/14.
//  Copyright (c) 2014 teamradness. All rights reserved.
//

import UIKit


// Example of extending UIColor with Custom Colors
extension UIColor {
    
    class pastCast {
        
        class func white(alpha:CGFloat = 1.0 ) -> UIColor {
            return UIColor(red: 0.98, green: 0.98,  blue: 0.945, alpha: alpha)
        }
        
        class func red(alpha:CGFloat = 1.0 ) -> UIColor {
            return UIColor(red: 1.0, green: 0.2862745,  blue: 0.2862745, alpha: alpha)
        }
        
        class func blue(alpha:CGFloat = 1.0 ) -> UIColor {
            return UIColor(red: 0.7176470588, green: 0.8941176471,  blue: 0.9294117647, alpha: alpha)
        }
    }
    
    
    class func moBlueColor(alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(red: 0.25, green: 0.5, blue: 0.85, alpha: alpha)
    }
    
    class func moPinkColor(alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(red: 0.93, green: 0.0, blue: 0.33, alpha: alpha)
    }
    
    class func moWhiteWarm(alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(red: 0.95, green: 0.94, blue: 0.93, alpha: alpha)
    }
    
    class func moWhiteCool(alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: alpha)
    }
    
    class func darkGray(alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(red:0.1, green: 0.1, blue: 0.1, alpha: alpha)
    }
}


// Custom Fonts :
extension UIFont {
    class func cycleThroughSysFonts () {
        for font : AnyObject in UIFont.familyNames() {
            println(font)
            
            for fontName : AnyObject in UIFont.fontNamesForFamilyName(font as String) {
                println(fontName)
            }
            
        }
    }
    
    
    
//    class func avenirLight(fontsize:CGFloat = 20) -> UIFont {
//        return UIFont(name: "Avenir-Light", size: fontsize)
//    }
    
    class func freightBigBlack(fontsize:CGFloat = 20) -> UIFont {
        return UIFont(name: "FreightBigBlack", size: fontsize)
    }
    
    class func freightBoldItalic(fontsize:CGFloat = 20) -> UIFont {
        return UIFont(name: "FreightBigBookItalic", size: fontsize)
    }
    
    class func futuraBook(fontsize:CGFloat = 20) -> UIFont {
        return UIFont(name: "Futura-Book", size: fontsize)
    }
    
    
}

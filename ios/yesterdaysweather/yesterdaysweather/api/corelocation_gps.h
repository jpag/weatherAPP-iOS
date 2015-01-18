//
//  corelocation_gps.h
//  yesterdaysweather
//
//  Created by jpg on 10/29/13.
//  Copyright (c) 2013 com.teamradness. All rights reserved.
// http://www.appcoda.com/how-to-get-current-location-iphone-user/

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "../global_constants.h"

@protocol gpsDelegate <NSObject>
-(void)gpsLoaded:(CLLocation *)gpsCoordinate;
@end

// <CLLocationManagerDelegate>
@interface corelocation_gps : NSObject <CLLocationManagerDelegate> {
    __unsafe_unretained id<gpsDelegate> delegate;
}

// PROPERTIES
@property(nonatomic,assign)id delegate;
@property(nonatomic,retain) CLLocationManager *locationManager;

//define functions it as a singleton:
+(corelocation_gps *)corelocationGPS;

//allow functions to be called from external views:
- (void)getGPS;

@end

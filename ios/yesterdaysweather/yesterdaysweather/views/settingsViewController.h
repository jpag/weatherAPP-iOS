//
//  settingsViewController.h
//  yesterdaysweather
//
//  Created by jpg on 11/27/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import <UIKit/UIKit.h>
@class api_forecast;

@interface settingsViewController : UIViewController{
    //api_forecast *weatherAPI;
}

// SINGLETONS
@property (strong, nonatomic) api_forecast *weatherAPI;
//@property (strong, nonatomic) corelocation_gps *gpsAPI;

@end

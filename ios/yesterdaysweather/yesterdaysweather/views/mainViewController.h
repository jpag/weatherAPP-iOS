//
//  mainViewController.h
//  yesterdaysweather
//
//  Created by jpg on 11/21/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "settingsViewController.h"

@class api_worldweatheronline;

@interface mainViewController : UIViewController{
    api_worldweatheronline *weatherAPI;
}

@property (nonatomic, strong) IBOutlet UILabel * label_lastchecked;
@property (nonatomic, strong) IBOutlet UILabel * label_todaysTemp;
@property (nonatomic, strong) IBOutlet UILabel * label_yesterdaysTemp;
@property (nonatomic, strong) IBOutlet UILabel * label_currentLocation;

@property (strong, nonatomic) settingsViewController *settingsController;

//@property (strong, nonatomic) api_worldweatheronline *weatherAPI;

@end

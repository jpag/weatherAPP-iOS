//
//  mainViewController.h
//  yesterdaysweather
//
//  Created by jpg on 11/21/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "settingsViewController.h"
#import "bkgdCustomMain.h"

@class api_forecast;
@class corelocation_gps;

@interface mainViewController : UIViewController{
    api_forecast *weatherAPI;
    corelocation_gps *gpsAPI;
}

// LABELS in the XIB view:
@property (nonatomic, strong) IBOutlet UILabel * label_lastchecked;


// TEXT FIELDS:
@property (nonatomic, strong) IBOutlet UITextField * tf_todaysTemp;
@property (nonatomic, strong) IBOutlet UITextField * tf_yesterdaysTemp;

@property (nonatomic, strong) IBOutlet UITextField * tf_todaysTime;
@property (nonatomic, strong) IBOutlet UITextField * tf_yesterdaysTime;

@property (nonatomic, strong) IBOutlet UITextField * tf_location;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, strong) IBOutlet UIButton *celOrFar;

- (IBAction)refreshData:(id)sender;
- (IBAction)changeDegrees:(id)sender;

// VIEWS
@property (strong, nonatomic) settingsViewController *settingsController;

// SINGLETONS
@property (strong, nonatomic) api_forecast *weatherAPI;
@property (strong, nonatomic) corelocation_gps *gpsAPI;

// OTHER VARIABLES

// must be a pointer because it is an object type:
@property(strong, nonatomic) bkgdCustomMain *bkgd;


@end

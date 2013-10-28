//
//  mainViewController.h
//  yesterdaysweather
//
//  Created by jpg on 11/21/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "settingsViewController.h"

//@class api_forecast;

@interface mainViewController : UIViewController{
    
    api_forecast *weatherAPI;
    
}

// LABELS in the XIB view
@property (nonatomic, strong) IBOutlet UILabel * label_lastchecked;
@property (nonatomic, strong) IBOutlet UILabel * label_todaysTemp;
@property (nonatomic, strong) IBOutlet UILabel * label_yesterdaysTemp;
@property (nonatomic, strong) IBOutlet UILabel * label_currentLocation;

@property (nonatomic, strong) IBOutlet UITextField * tf_todaysTemp;
@property (nonatomic, strong) IBOutlet UITextField * tf_yesterdaysTemp;

@property (nonatomic, strong) IBOutlet UITextField * tf_todaysTime;
@property (nonatomic, strong) IBOutlet UITextField * tf_yesterdaysTime;


@property (strong, nonatomic) settingsViewController *settingsController;

@property (strong, nonatomic) api_forecast *weatherAPI;

@end

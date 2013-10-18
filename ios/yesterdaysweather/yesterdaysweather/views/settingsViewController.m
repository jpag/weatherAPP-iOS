//
//  settingsViewController.m
//  yesterdaysweather
//
//  Created by jpg on 11/27/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

// SETTINGS:
// -set/update/change location
//      GPS or Manual Autocomplete
// -change C/F temparture


#import "settingsViewController.h"
#import "api_forecast.h"

@interface settingsViewController ()

@end

@implementation settingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    weatherAPI = [api_forecast apiForecast];
    
    NSLog(@" settings view init...");
    NSLog(@"weather some num model singleton example: %d " , weatherAPI.someNum );
    
    NSLog(@"weather some Current Time: %@ " , weatherAPI.currentTime );
    
    //TEST:
    weatherAPI.delegate = self;
    // [weatherAPI getCities];
    
}

//- (void)cityList:(NSArray*)cities{
//    NSLog(@" cities in settings %lu", (unsigned long)cities.count );
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

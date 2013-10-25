//
//  mainViewController.m
//  yesterdaysweather
//
//  Created by jpg on 11/21/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import "mainViewController.h"
#import "api_forecast.h"

@interface mainViewController ()

@end

@implementation mainViewController

//synthesize here
@synthesize settingsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    weatherAPI = [api_forecast apiForecast];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self update];
    // [self displaySettingsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)update
{
    NSLog(@"update()");
    
    //check if enough time has elapsed to update or to pass?
    //if( ){ }
    
    //run update
    weatherAPI.delegate = self;
    
    [weatherAPI getTemperature];
    
}

-(void)temperatureLoaded:(NSArray *)temps{
    NSLog(@" ------ %@", temps);
    NSLog(@" TEMPS returned to MAIN VIEW! ");
    
}

- (void)displaySettingsView
{
    //test passing of the singleton object information from one view to another.
    weatherAPI.someNum = 5;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.settingsController = [[settingsViewController alloc] initWithNibName:@"settingsViewController_iPhone" bundle:nil];
    } else {
        NSLog(@"warning no settings panel made for ipad");
        //self.settingsController = [[settingsViewController alloc] initWithNibName:@"settingsViewController_iPad" bundle:nil];
    }

    //add to view:
    [self.view addSubview:settingsController.view];
    
}

@end

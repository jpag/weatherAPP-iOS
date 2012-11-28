//
//  mainViewController.m
//  yesterdaysweather
//
//  Created by jpg on 11/21/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import "mainViewController.h"
#import "api_worldweatheronline.h"

@interface mainViewController ()

@end

@implementation mainViewController

//synthesize here
@synthesize weatherAPI;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self update];
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
    
    //get city/location id
    
    
    //query api for location.
    //create api if it does not exist.
    if( self.weatherAPI == NULL ){
        NSLog(@"weather API is null create it");
        self.weatherAPI = [[api_worldweatheronline alloc] init];
    }
    
    [self.weatherAPI getCities];
    
}


@end

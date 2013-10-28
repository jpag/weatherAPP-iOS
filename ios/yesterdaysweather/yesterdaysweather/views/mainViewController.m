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
@synthesize tf_todaysTemp;
@synthesize tf_yesterdaysTemp;
@synthesize tf_todaysTime;
@synthesize tf_yesterdaysTime;


@synthesize settingsController;
@synthesize weatherAPI;

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

-(void)temperatureLoaded:(NSDictionary *)temps{
    NSLog(@" ------ %@", temps);
    NSLog(@" TEMPS returned to MAIN VIEW! %@" , [temps objectForKey:@"pastTemp"]  );

    tf_yesterdaysTemp.text = [[temps objectForKey:@"pastTemp"]stringValue];
    tf_todaysTemp.text = [[temps objectForKey:@"presentTemp"]stringValue];
    
    tf_yesterdaysTime.text = [self renderDate:[[temps objectForKey:@"pastTime"]stringValue]];
    tf_todaysTime.text = [self renderDate:[[temps objectForKey:@"presentTime"]stringValue]];
}

-(NSString *)renderDate:(NSString *)strDate{
    NSTimeInterval _interval=[strDate doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];

    // http://stackoverflow.com/questions/7507003/objective-c-help-me-convert-a-timestamp-to-a-formatted-date-time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"mm dd yyyy"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *dateFormated = [formatter stringFromDate:date];
    // ARC no longer need this: [formatter release];
    
    NSLog(@"%@", dateFormated);
    
    return dateFormated;
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

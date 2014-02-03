//
//  mainViewController.m
//  yesterdaysweather
//
//  Created by jpg on 11/21/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import "mainViewController.h"
#import "api_forecast.h"
#import "corelocation_gps.h"

@interface mainViewController ()
@end

@implementation mainViewController

//synthesize here
@synthesize tf_todaysTemp;
@synthesize tf_yesterdaysTemp;
@synthesize tf_todaysTime;
@synthesize tf_yesterdaysTime;
@synthesize tf_location;


@synthesize indicator;

@synthesize settingsController;
@synthesize weatherAPI;
@synthesize gpsAPI;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    weatherAPI = [api_forecast apiForecast];
    gpsAPI = [corelocation_gps corelocationGPS];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    [self update];
    // [self displaySettingsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshData:(id)sender {
    NSLog(@"---- REFRESH DATA");
    
    tf_yesterdaysTemp.text = @"";
    tf_todaysTemp.text = @"";
    
    tf_yesterdaysTime.text = @"";
    tf_todaysTime.text = @"";
    
    tf_location.text = @"";
    
    [self update];
}

- (IBAction)changeDegrees:(id)sender {
    if( weatherAPI.isCelsius == true ){
        weatherAPI.isCelsius = false;
        NSLog(@"----- change degrees to F.");
    }else{
        weatherAPI.isCelsius = true;
        NSLog(@"----- change degrees to C.");
    }
}

- (void)update
{
    NSLog(@"update()");
    
    indicator.hidden = false;
    //check if enough time has elapsed to update or to pass?
    //if( ){ }
    gpsAPI.delegate = self;
    [gpsAPI getGPS];
    //run update
}

-(void)gpsLoaded:(CLLocation *)gpsCoordinate{
    
    weatherAPI.coordinates = gpsCoordinate.coordinate;
    // round the values to solid numbers:
    // tf_lng.text = [NSString stringWithFormat:@"Longitude %.0f", gpsCoordinate.coordinate.longitude];
    // tf_lat.text = [NSString stringWithFormat:@"Latitude %.0f", gpsCoordinate.coordinate.latitude];
    
    //tf_location.text = [NSString stringWithFormat:@"Lg:%.0f Lt:%.0f", gpsCoordinate.coordinate.longitude, gpsCoordinate.coordinate.latitude];

    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:gpsCoordinate completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString *city = [placemark locality];
            NSString *country = [placemark administrativeArea];
            
            tf_location.text = [NSString stringWithFormat:@"%@, %@ Lg:%.0f Lt:%.0f", city, country, gpsCoordinate.coordinate.longitude, gpsCoordinate.coordinate.latitude];
        }
    }];
    
    [self updateWeather];
}

-(void)updateWeather{
    weatherAPI.delegate = self;
    [weatherAPI getTemperature];
}

-(void)temperatureLoaded:(NSDictionary *)temps{
    NSLog(@" ------ %@", temps);
    NSLog(@" TEMPS returned to MAIN VIEW! %@" , [temps objectForKey:@"pastTemp"]  );

    tf_yesterdaysTemp.text = [[temps objectForKey:@"pastTemp"]stringValue];
    tf_todaysTemp.text = [[temps objectForKey:@"presentTemp"]stringValue];
    
    if(  [temps objectForKey:@"presentTemp"] < [temps objectForKey:@"pastTemp"] ){
        NSLog(@" colder draw");
        // colder today
        [self drawColorBlock:[UIColor blueColor]];
    }else if( [temps objectForKey:@"presentTemp"] > [temps objectForKey:@"pastTemp"] ) {
        NSLog(@" warmer draw");
        // warmer today
        [self drawColorBlock:[UIColor redColor]];
    }else {
        // equal
        [self drawColorBlock:[UIColor greenColor]];
    }
    
    tf_yesterdaysTime.text = [self renderDate:[[temps objectForKey:@"pastTime"]stringValue]];
    tf_todaysTime.text = [self renderDate:[[temps objectForKey:@"presentTime"]stringValue]];
    
    indicator.hidden = true;
}

-(void)drawColorBlock:(UIColor *)col{
    //    UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, self.view.frame.size.width, 0);
//    CGContextAddLineToPoint(context, self.view.frame.size.width, self.view.frame.size.height/2);
//    CGContextAddLineToPoint(context, 0, self.view.frame.size.height/2);
    CGContextAddLineToPoint(context, 500, 0);
    CGContextAddLineToPoint(context, 500,200);
    CGContextAddLineToPoint(context, 0, 200);
    CGContextAddLineToPoint(context, 0, 0);
//    CGContextSetAlpha(context, .5);
    CGContextSetFillColorWithColor(context,
                                   col.CGColor);
    CGContextFillPath(context);
    
    UIGraphicsEndImageContext();
}

-(void)drawWarmer{
    
}

-(void)drawEqual{
    
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

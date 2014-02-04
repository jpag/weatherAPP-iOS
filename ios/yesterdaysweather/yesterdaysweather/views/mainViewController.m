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
#import "bkgdCustomMain.h"

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

@synthesize bkgd;

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
    
    // warm or cold ?
    // STRING TO FLOAT:
    //float yTemp = [[temps objectForKey:@"pastTemp"] floatValue];
    float tTemp = [[temps objectForKey:@"presentTemp"] floatValue];
    UIColor *tempColor = [self colorCold];
    BOOL drawTop = true;
    
    if( weatherAPI.isCelsius == true ){
        if( tTemp >= 10.0 ){
            tempColor = [self colorWarm];
        }
    }else {
        // FAREN
        if( tTemp >= 50 ){
            tempColor = [self colorWarm];
        }
    }
    
    
    tf_yesterdaysTemp.text = [[temps objectForKey:@"pastTemp"]stringValue];
    tf_todaysTemp.text = [[temps objectForKey:@"presentTemp"]stringValue];
    
    if(  [temps objectForKey:@"presentTemp"] < [temps objectForKey:@"pastTemp"] ){
        NSLog(@" colder today draw");
        // warmer YESTERDAY
        
        tf_todaysTemp.textColor = [self colorWhite];
        tf_yesterdaysTemp.textColor = [self colorCold];
        drawTop = false;
        
    }else if( [temps objectForKey:@"presentTemp"] > [temps objectForKey:@"pastTemp"] ) {
        NSLog(@" warmer today draw");
        // warmer today
        
        tf_todaysTemp.textColor = tempColor;
        tf_yesterdaysTemp.textColor = [self colorWhite];
        
    }else {
        // equal
    }

    [self drawColorBlock:tempColor second:drawTop];
    
    tf_yesterdaysTime.text = [self renderDate:[[temps objectForKey:@"pastTime"]stringValue]];
    tf_todaysTime.text = [self renderDate:[[temps objectForKey:@"presentTime"]stringValue]];
    
    indicator.hidden = true;
}

-(UIColor*)colorCold {
    return [UIColor colorWithRed:141.0f/255.0f green:211.0f/255.0f blue:244.0f/255.0f alpha:.7];
}

-(UIColor*)colorWarm {
    return [UIColor colorWithRed:244.0f/255.0f green:211.0f/255.0f blue:141.0f/255.0f alpha:.7];
}

-(UIColor*)colorWhite {
    return [UIColor colorWithRed:1 green:1 blue:1 alpha: .7];
}

-(void)drawColorBlock:(UIColor *)col second:(BOOL)top{
    // START NEW
    
    if( top == true ){
        // DRAW UP TOP
    }else{
        // DRAW BOTTOM
        
    }
    
    float x = 0;
    float y = (top == true)? 0 : self.view.bounds.size.height/2;
    float w = self.view.bounds.size.width;
    float h = self.view.bounds.size.height/2;
    
    self.bkgd = [[bkgdCustomMain alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    [self.view addSubview:bkgd];
    [self.view sendSubviewToBack:bkgd];
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

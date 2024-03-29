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
//@synthesize tf_todaysTemp;
//@synthesize tf_yesterdaysTemp;
//@synthesize tf_todaysTime;
//@synthesize tf_yesterdaysTime;
//@synthesize tf_location;
//@synthesize celOrFar;
//@synthesize indicator;
//@synthesize settingsController;
//@synthesize weatherAPI;
//@synthesize gpsAPI;
//@synthesize bkgd;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _weatherAPI = [api_forecast apiForecast];
    _gpsAPI = [corelocation_gps corelocationGPS];
    
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
    
    [self update];
}

- (IBAction)changeDegrees:(id)sender {
    NSString *degree = @"C";
    if( _weatherAPI.isCelsius == true ){
        _weatherAPI.isCelsius = false;
        NSLog(@"----- change degrees to F.");
        degree = @"F";
    }else{
        _weatherAPI.isCelsius = true;
        NSLog(@"----- change degrees to C.");
    }
    
    //celOrFar.setTitle = degree;
    [_celOrFar setTitle:degree forState:UIControlStateNormal];
    
    //[self update];
}

- (void)update
{
    NSLog(@"update()");
    
    _tf_yesterdaysTemp.text = @" ";
    _tf_todaysTemp.text = @" ";
    
    _tf_yesterdaysTime.text = @"";
    _tf_todaysTime.text = @"";
    
    _tf_location.text = @"";
    
    _indicator.hidden = false;
    //check if enough time has elapsed to update or to pass?
    //if( ){ }
    _gpsAPI.delegate = self;
    [_gpsAPI getGPS];
    //run update
}

-(void)gpsLoaded:(CLLocation *)gpsCoordinate{
    
    _weatherAPI.coordinates = gpsCoordinate.coordinate;
    // round the values to solid numbers:
    // tf_lng.text = [NSString stringWithFormat:@"Longitude %.0f", gpsCoordinate.coordinate.longitude];
    // tf_lat.text = [NSString stringWithFormat:@"Latitude %.0f", gpsCoordinate.coordinate.latitude];
    
    //tf_location.text = [NSString stringWithFormat:@"Lg:%.0f Lt:%.0f", gpsCoordinate.coordinate.longitude, gpsCoordinate.coordinate.latitude];

    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:gpsCoordinate completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString *city = [placemark locality];
            NSString *country = [placemark administrativeArea];
            
            _tf_location.text = [NSString stringWithFormat:@"%@, %@ Lg:%.0f Lt:%.0f", city, country, gpsCoordinate.coordinate.longitude, gpsCoordinate.coordinate.latitude];
        }
    }];
    
    [self updateWeather];
}

-(void)updateWeather{
    _weatherAPI.delegate = self;
    [_weatherAPI getTemperature];
}

-(void)temperatureLoaded:(NSDictionary *)temps{
    NSLog(@" ------ %@", temps);
    NSLog(@" TEMPS returned to MAIN VIEW! %@" , [temps objectForKey:@"pastTemp"]  );
    
    // warm or cold ?
    // STRING TO FLOAT:
    //float yTemp = [[temps objectForKey:@"pastTemp"] floatValue];
    float tTemp = [[temps objectForKey:@"presentTemp"] floatValue];
    float yTemp = [[temps objectForKey:@"pastTemp"] floatValue];
    UIColor *tempColor = [self colorCold];
    UIColor *topColor;
    UIColor *bottomColor;
    BOOL drawTop = true;
    BOOL isWarm = false;
    
    if( _weatherAPI.isCelsius == true ){
        if( tTemp >= 10.0 ){
            tempColor = [self colorWarm];
            isWarm = true;
        }
    }else {
        // FAREN
        if( tTemp >= 50 ){
            tempColor = [self colorWarm];
            isWarm = true;
        }
    }
    
    _tf_yesterdaysTemp.text = [[temps objectForKey:@"pastTemp"]stringValue];
    _tf_todaysTemp.text = [[temps objectForKey:@"presentTemp"]stringValue];
    
    if(  tTemp < yTemp ){
        NSLog(@" colder today draw");
        
        if( isWarm == false ){
            // it was colder today...
            drawTop = true;
            topColor = [self colorWhite];
            bottomColor = [self colorCold];
        }else {
            // it was warmer yesterday
            drawTop = false;
            topColor = [self colorCold];
            bottomColor = [self colorWhite];
        }
        
    }else if( tTemp > yTemp ) {
        NSLog(@" warmer today draw");
        // warmer today
        
        if( isWarm == false){
            // colder today
            drawTop = false;
            topColor = tempColor;
            bottomColor = [self colorWhite];
        }else {
            // warmer today
            drawTop = true;
            topColor = [self colorWhite];
            bottomColor = tempColor;
        }
    }else {
        // equal
    }
    
    _tf_location.textColor = topColor;
    _tf_todaysTemp.textColor = _tf_todaysTime.textColor = topColor;
    _tf_yesterdaysTime.textColor = _tf_yesterdaysTemp.textColor = bottomColor;

    [self drawColorBlock:tempColor second:drawTop];
    
    _tf_yesterdaysTime.text = [self renderDate:[[temps objectForKey:@"pastTime"]stringValue]];
    _tf_todaysTime.text = [self renderDate:[[temps objectForKey:@"presentTime"]stringValue]];
    
    _indicator.hidden = true;
}

-(UIColor*)colorCold {
    return [UIColor colorWithRed:141.0f/255.0f green:211.0f/255.0f blue:244.0f/255.0f alpha:.9];
}

-(UIColor*)colorWarm {
    return [UIColor colorWithRed:244.0f/255.0f green:211.0f/255.0f blue:141.0f/255.0f alpha:.9];
}

-(UIColor*)colorWhite {
    return [UIColor colorWithRed:1 green:1 blue:1 alpha: .9];
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
    
    NSArray *keys = [NSArray arrayWithObjects:@"color", nil];
    NSArray *objects = [NSArray arrayWithObjects:col, nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
    
    NSLog(@" IS TOP? %d y %f", top , y);
    self.bkgd = [[bkgdCustomMain alloc] initWithFrame:CGRectMake(x, y, w, h) second:params];
    
    [self.view addSubview:_bkgd];
    [self.view sendSubviewToBack:_bkgd];
}


-(NSString *)renderDate:(NSString *)strDate{
    NSTimeInterval _interval=[strDate doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];

    // http://stackoverflow.com/questions/7507003/objective-c-help-me-convert-a-timestamp-to-a-formatted-date-time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"mm dd yyyy"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //[formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *dateFormated = [formatter stringFromDate:date];
    // ARC no longer need this: [formatter release];
    
    NSLog(@"%@", dateFormated);
    
    return dateFormated;
}

- (void)displaySettingsView
{
    //test passing of the singleton object information from one view to another.
    _weatherAPI.someNum = 5;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.settingsController = [[settingsViewController alloc] initWithNibName:@"settingsViewController_iPhone" bundle:nil];
    } else {
        NSLog(@"warning no settings panel made for ipad");
        //self.settingsController = [[settingsViewController alloc] initWithNibName:@"settingsViewController_iPad" bundle:nil];
    }

    //add to view:
    [self.view addSubview:_settingsController.view];
    
}

@end

//
//  api_worldweatheronline.m
//  yesterdaysweather
//
//  Created by jpg on 11/27/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import "api_worldweatheronline.h"

#define requestURL_domain   [NSURL URLWithString: @"http://local.weatherapp.com"];
#define requestURL_cities   [NSURL URLWithString: @"/api/citylist/"];
#define requestURL_byName   [NSURL URLWithString: @"/api/city/"];
#define requestURL_byID     [NSURL URLWithString: @"/api/cityid/"];

@interface api_worldweatheronline();

@end;

@implementation api_worldweatheronline

-(id)init
{
    if((self = [super init] )){
        //perform own initialization here;
        //self.text = @"hello";
    }
    return self;
}

//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    
//}


- (void)getCities
{
        
    NSLog(@"get cities");
    //return json
}


@end

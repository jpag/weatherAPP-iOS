//
//  api_worldweatheronline.m
//  yesterdaysweather
//
//  Created by jpg on 11/27/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//
// mainly this source:
//  http://klanguedoc.hubpages.com/hub/iOS-5-How-To-Share-Data-Between-View-Controllers-using-a-Singleton
// and a bit of:
//  http://gigaom.com/apple/iphone-dev-sessions-using-singletons/
//  http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html

#import "api_worldweatheronline.h"

#define requestURL_domain   [NSURL URLWithString: @"http://local.weatherapp.com"];
#define requestURL_cities   [NSURL URLWithString: @"/api/citylist/"];
#define requestURL_byName   [NSURL URLWithString: @"/api/city/"];
#define requestURL_byID     [NSURL URLWithString: @"/api/cityid/"];

@interface api_worldweatheronline();

@end;


@implementation api_worldweatheronline

//SYNTHESIZE HERE:
@synthesize someNum;

+(api_worldweatheronline *)apiWorldWeather{
    static api_worldweatheronline *apiWorldWeatherSingleton = nil;
    
    @synchronized(self){
        
        NSLog(@"creating singleton API WorldWeatherOnline");
        
        if( apiWorldWeatherSingleton == nil ){
            apiWorldWeatherSingleton = [[api_worldweatheronline alloc] init];
        }
    }
    return apiWorldWeatherSingleton;
}



//-(id)init
//{
//    if((self = [super init] )){
//        //perform own initialization here;
//        //self.text = @"hello";
//    }
//    return self;
//}

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
    //check cache date of cities list.
    
    //if over a day old
        //query for new list
    //else
        //show cache
    
    //return result
}

- (void)matchClosestCityToLatLong
{
    NSLog(@"matchClosestCityToLatLong()");
    
    //get the lat long values
    
    //call getCities()
    
    //eval values to determine which cities are closest
    
    //maybe return 1 or more... to suggest other options?
    
}


- (void)getTemperature
{
    NSLog(@"getTemperature()");
    //has city?
    
    //what temperature type?
    
    //return results:
    
}


@end


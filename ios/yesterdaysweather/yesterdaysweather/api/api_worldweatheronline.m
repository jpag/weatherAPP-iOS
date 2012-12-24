//
//  api_worldweatheronline.m
//  yesterdaysweather
//
//  Created by jpg on 11/27/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.

//  THIS CLASS IS TREATED AS A SINGLETON TO SHARE DATA BETWEEN VIEWS
//  DATA SHOULD BE STORED IN LOCAL STORAGE FOR EASY ACCESS

// mainly this REF:
//  http://klanguedoc.hubpages.com/hub/iOS-5-How-To-Share-Data-Between-View-Controllers-using-a-Singleton

// and a bit of:
//  http://gigaom.com/apple/iphone-dev-sessions-using-singletons/
//  http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html


//  LOCAL STORAGE:


#import "api_worldweatheronline.h"

@interface api_worldweatheronline();

@end;


@implementation api_worldweatheronline

//SYNTHESIZE HERE:
@synthesize someNum;
@synthesize lastPullRequest; //taken from core if it exists.
@synthesize currentTime;
@synthesize cacheExpired;

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

// compare now to the last update made..
// check to see if the cache is valid or needs updating
- (void)setCurrentTime
{
    if( currentTime == nil ){
        
        currentTime = [NSDate date];
        
        //get last cache pull from LOCAL STORAGE:
        
        //compare time add expiresin value:
        int expiresIn = CACHE_EXPIRES;

//http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtDates.html
//        NSTimeInterval secondsPerDay = 24 * 60 * 60;
//        NSDate *tomorrow = [[NSDate alloc]
//                            initWithTimeIntervalSinceNow:secondsPerDay];
//        NSDate *yesterday = [[NSDate alloc]
//                             initWithTimeIntervalSinceNow:-secondsPerDay];
//        [tomorrow release];
//        [yesterday release];
        
        
        NSLog(@" cache expires: %d ", expiresIn );
        cacheExpired = false;
    }
    //compare
}


- (void)getCities
{
    
    NSLog(@"get cities");
    
    [self setCurrentTime];
    
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
    [self setCurrentTime];
    
    
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


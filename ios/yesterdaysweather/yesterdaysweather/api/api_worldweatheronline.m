//
//  api_worldweatheronline.m
//  yesterdaysweather
//
//  Created by jpg on 11/27/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.

//  THIS CLASS IS TREATED AS A SINGLETON TO SHARE DATA BETWEEN VIEWS
//  DATA SHOULD BE STORED IN LOCAL STORAGE FOR EASY ACCESS

//  LOCAL STORAGE:

#import "api_worldweatheronline.h"

@interface api_worldweatheronline();

@end;


@implementation api_worldweatheronline

//SYNTHESIZE HERE:
@synthesize CoreData_lastUpdate;

@synthesize someNum;
@synthesize lastPullRequest; //taken from core if it exists.
@synthesize currentTime;
//@synthesize cacheExpired;

//@synthesize fetchedResultsController = __fetchedResultsController;
//@synthesize managedObjectContext = __managedObjectContext;


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
- (Boolean)useCache
{
    if( currentTime == nil ){
        
        currentTime = [NSDate date];
    }
    
    //get last cache pull from LOCAL STORAGE:
    
    //compare time add expiresin value:
    int expiresIn = CACHE_EXPIRES;
    
    CoreData_lastUpdate.lastPullRequest = currentTime;
    
    NSLog( @"CoreData_lastUpdate.lastPullRequest %@", CoreData_lastUpdate.lastPullRequest );
    
    //http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtDates.html
    //        NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //        NSDate *tomorrow = [[NSDate alloc]
    //                            initWithTimeIntervalSinceNow:secondsPerDay];
    //        NSDate *yesterday = [[NSDate alloc]
    //                             initWithTimeIntervalSinceNow:-secondsPerDay];
    //        [tomorrow release];
    //        [yesterday release];
    
    
    NSLog(@" cache expires: %d ", expiresIn );

    //compare

    
    //cacheExpired = false;
    return false;

}


- (void)getCities
{
    
    NSLog(@"get cities");
    
    //check cache date of cities list.
    if( [self useCache] == true ){
        //return city list:
        
    }else{
        //NO CACHE:
        //call JSON city list
        //write to Core Data
        //return city list
    }
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
    
    if( [self useCache] == true ){
        //return temperature list:
        
    }else{
        //NO CACHE:
        //call JSON temperature list
        //write to Core Data
        //return temperature list
    }
    
}


@end


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

// http://www.raywenderlich.com/5492/working-with-json-in-ios-5 
#define apiQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT , 0 )

@interface api_worldweatheronline();
@end;

@implementation api_worldweatheronline

//SYNTHESIZE HERE:
@synthesize delegate;

//test item:
@synthesize someNum;

@synthesize lastPullRequest; //taken from core if it exists.
@synthesize currentTime;

//@synthesize managedObjectContext = __managedObjectContext;
//@synthesize managedObjectModel = __managedObjectModel;
//@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;



+(api_worldweatheronline *)apiWorldWeather{
    static api_worldweatheronline *apiWorldWeatherSingleton = nil;
    
    @synchronized(self){
        
        NSLog(@"-----SINGLETON CREATED - API WorldWeatherOnline------");
        
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
    // int expiresIn = CACHE_EXPIRES;
    
    //CoreData_lastUpdate.lastPullRequest = currentTime;
    //NSLog( @"CoreData_lastUpdate.lastPullRequest %@", CoreData_lastUpdate.lastPullRequest );
    
    //http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtDates.html
    //        NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //        NSDate *tomorrow = [[NSDate alloc]
    //                            initWithTimeIntervalSinceNow:secondsPerDay];
    //        NSDate *yesterday = [[NSDate alloc]
    //                             initWithTimeIntervalSinceNow:-secondsPerDay];
    //        [tomorrow release];
    //        [yesterday release];
    
    
    //NSLog(@" cache expires: %d ", expiresIn );

    //compare

    //cacheExpired = false;
    return false;
}

- (void)isCityDefined
{
    NSLog(@" --- isCityDefined");
    //find a city if it is defined in the core data
    //BOOL *listen = [delegate respondsToSelector:@selector(wasCityDefined:)];
    //NSLog(@"is listening %s" , listen);
    [delegate wasCityDefined: FALSE ];
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
        
        NSString *path = PATH_CITIES;
        NSLog(@"  ---- load cities %@ ----", path );
        [self jsonRequest:path];
        
        NSLog(@"Get cities is complete");
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
    NSLog(@" --- getTemperature() ---- ");
    
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

- (void)loadTemperature
{
    NSString *path = PATH_byID;
    //get current setting CITY ID
    NSString *id = 0;
    path = [path stringByAppendingString:id];
    //[self jsonRequest:path];
}

#pragma mark - JSON REQUEST
- (void)jsonRequest:(NSString*)urlPath
{
    
    NSString *stringURL = URL_DOMAIN;
    stringURL = [stringURL stringByAppendingString:urlPath];
    //NSLog(@" url path %@", stringURL );
    NSURL * url = [NSURL URLWithString:stringURL];
    
    // Remember it is only OK to run a synchronous method
    // such as dataWithContentsOfURL in a background thread,
    // otherwise the GUI will seem unresponsive to the user.
    
    dispatch_async(apiQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the JSON data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error ];
    
    //do a switch case here to determine which delegate protocol to request:
    //Is anyone listening
    if( [json objectForKey:@"cities"] && [delegate respondsToSelector:@selector(cityList:)] ){
        NSArray* cities = [json objectForKey:@"cities"];
        NSLog(@" cities loaded : %@", cities[0]);
        
        [delegate cityList: cities ];
    }else if( [json objectForKey:@"days"] && [delegate respondsToSelector:@selector(temperatureList:)] ){
        NSArray* temps = [json objectForKey:@"days"];
        NSLog(@" temperature days loaded : %@", temps[0]);
        
        [delegate temperatureList: temps];
    }else{
        NSLog(@" API weather fetched Data - NO Key found matches request ");
    }
    
}



@end


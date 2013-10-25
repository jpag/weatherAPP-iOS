//
//  api_forecast.m
//  yesterdaysweather
//  Using forecast.io

//
//  Created by jpg on 10/18/13.
//  Copyright (c) 2013 com.teamradness. All rights reserved.
//

#import "api_forecast.h"

// http://www.raywenderlich.com/5492/working-with-json-in-ios-5 
#define apiQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT , 0 )

@interface api_forecast();
@end;

@implementation api_forecast

//SYNTHESIZE HERE:
@synthesize delegate;

//test item:
@synthesize someNum;

@synthesize lastPullRequest; //taken from core if it exists.
@synthesize currentTime;

//@synthesize managedObjectContext = __managedObjectContext;
//@synthesize managedObjectModel = __managedObjectModel;
//@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

+(api_forecast *)apiForecast{
	static api_forecast *apiForecastSingleton = nil;

	@synchronized(self){
		NSLog(@"---- SINGLETON CREATED - API Forecast io");

		if( apiForecastSingleton == nil ){
			apiForecastSingleton = [[api_forecast alloc] init];
		}
	}
	return apiForecastSingleton;
}

-(Boolean)useCache
{

	if(currentTime== nil ){
		currentTime = [NSDate date];
	}

	// int expiresIn = CACHE_EXPIRES;

	//compare time 
	//get last cache pull from Local Storage

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

	// For now we are just going to always return false
	return false;
}	


- (void)getTemperature
{
    NSLog(@" --- getTemperature() ---- ");
    
    //has city?
    
    //what temperature type?
    
    if( [self useCache] == true ){
        //dispatch to delegate temperature list:
        
    }else{
        //NO CACHE:
        //call JSON temperature list
        [self loadTemperature];
        
        //write to Core Data
        
        //return temperature list
    }
}

- (void)loadTemperature
{
    // Temperature format: api/lat/[XXX]/lng/[XXX]/u/[xx]
    
    // GET GPS:
    NSString* lat = [NSString stringWithFormat:@"lat/%d/", 40];
    NSString* lng = [NSString stringWithFormat:@"lng/%d/", -73];
    
    // GET Unit of Measurement
    NSString* unit = @"u/si/";
    
    
    // FORM PATH URL
    NSString *path = PATH_API;
    path = [path stringByAppendingString:lat];
    path = [path stringByAppendingString:lng];
    path = [path stringByAppendingString:unit];
    
    NSLog(@" path: %@", path);
    
    NSString *request = URL_DOMAIN;
    request = [request stringByAppendingString:path];
    [self jsonRequest:request];
}

#pragma mark - JSON REQUEST
// http://www.raywenderlich.com/5492/
- (void)jsonRequest:(NSString*)urlPath
{
    
    //NSLog(@" url path %@", stringURL );
    NSURL * url = [NSURL URLWithString:urlPath];
    
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
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error ];
     if (!json) {
         /* Handle the error */
         NSLog(@" ---- JSON ---- ERROR ----");
     }
    
    NSLog(@" ------ JSON loaded -----");
    // timecompared the default json request
    if( [json objectForKey:@"timecompared"] ){
        NSDictionary* dataReturned = [json objectForKey:@"timecompared"];
        
        // past > currently > temperature
        // present > currently > temperature
        
        NSDictionary* currentPastData = [[dataReturned objectForKey:@"past" ] objectForKey:@"currently"];
        NSDictionary* currentPresentData = [[dataReturned objectForKey:@"present" ] objectForKey:@"currently"];
        
        NSString* pastTemp = [currentPastData objectForKey:@"temperature"];
        NSString* pastTime = [currentPastData objectForKey:@"time"];
        
        NSString* presentTemp = [currentPresentData objectForKey:@"temperature"];
        NSString* presentTime = [currentPresentData objectForKey:@"time"];
        
        NSArray *keys = [NSArray arrayWithObjects:@"pastTime", @"pastTemp", @"presentTime", @"presentTemp", nil];
        NSArray *objects = [NSArray arrayWithObjects:pastTime, pastTemp, presentTime, presentTemp, nil];
        
        NSDictionary *pastAndPresent = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        
        [delegate temperatureLoaded: pastAndPresent];
    }
    
    //do a switch case here to determine which delegate protocol to request:
    /*
    if( [json objectForKey:@"cities"] && [delegate respondsToSelector:@selector(cityList:)] ){
        NSArray* cities = [json objectForKey:@"cities"];
        NSLog(@" cities loaded : %@", cities[0]);
        
        // [delegate cityList: cities ];
    }else if( [json objectForKey:@"days"] && [delegate respondsToSelector:@selector(temperatureList:)] ){
        NSArray* temps = [json objectForKey:@"days"];
        NSLog(@" temperature days loaded : %@", temps[0]);
        
        // [delegate temperatureList: temps];
    }else{
        NSLog(@" API weather fetched Data - NO Key found matches request ");
    }
    */
}


@end

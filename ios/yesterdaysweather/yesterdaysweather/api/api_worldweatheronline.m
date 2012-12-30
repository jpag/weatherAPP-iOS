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

//test item:
@synthesize someNum;


@synthesize lastPullRequest; //taken from core if it exists.
@synthesize currentTime;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


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
        
        NSString *path = PATH_CITIES;
        NSLog(@" load cities %@", path );
        [self jsonRequest:path];
        
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
    NSLog(@" url path %@", stringURL );
    NSURL * url = [NSURL URLWithString:stringURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //http://afnetworking.github.com/AFNetworking/Classes/AFJSONRequestOperation.html
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //NSLog(@"SUCCESS: %@", JSON);
            [self jsonLoaded:JSON];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON ) {
            NSLog(@"Error searching for songs: %@", error);
            [self jsonFailed];
        }];
    
    [operation start];
    
}

- (void)jsonLoaded:(id)JSON{
    
    NSLog(@" JSON LOADED %@", JSON);
    NSString *type = [JSON objectForKey:@"type"];
    if( [type isEqualToString:@"error"]){
        NSLog(@"ERROR HAPPENED");
        
    }else if( [type isEqualToString:@"cities"] ){
        NSLog(@" IS CITY LIST");
        
    }else if ([type isEqualToString:@"temps"]){
        NSLog(@" IS TEMPERATURES");
        
    }
}

- (void)jsonFailed
{
    //remove loader icon if any?
}


//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}


#pragma mark - Core Data stack
// ray saves the day again...
// http://www.raywenderlich.com/934/core-data-on-ios-5-tutorial-getting-started

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"apiWorldWeather" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"apiWorldWeather"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end


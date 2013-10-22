//
//  api_forecast.h
//  yesterdaysweather
//
//  Created by jpg on 10/18/13.
//  Copyright (c) 2013 com.teamradness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../global_constants.h"

//http://timroadley.com/2012/02/12/core-data-basics-part-2-core-data-views/
//#import "../CoreDataTableViewController/CoreDataTableViewController.h" // so we can fetch

//DATA model header ref:
#import "../models/Day.h"
#import "../models/Settings.h"

//Weather Delegate
@protocol WeatherDelegate <NSObject>
@optional
// - (void)temperatureList:(NSArray*)temps;
// - (void)getTemperature:(NSArray*)temps;
@end


@interface api_forecast : NSObject{
	__unsafe_unretained id<WeatherDelegate> delegate;
}

@property(nonatomic,assign)id delegate;
//test item
//ints are not pointers:
@property(nonatomic, assign) NSInteger someNum;

//dates are pointers
@property(nonatomic, retain) NSDate *lastPullRequest;
@property(nonatomic, retain) NSDate *currentTime;

/*
//core data:
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
// “scratch pad” for Core Data in the application for managing fetching, updating,
// and creating records in the store. It also manages a few fundamental features in
// Core Data including validations and undo/redo management for the records.
// The managed object context is the connection between your code and the data store

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//the database schema. It is a class that contains definitions for each of
//the objects (also called “Entities”) that you are storing in the database.

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//the database connection. Here’s where you set up the actual names and
//locations of what databases will be used to store the objects,
*/

//define functions it as a singleton:
+(api_forecast *)apiForecast;

//functions:
- (void)getTemperature;



@end
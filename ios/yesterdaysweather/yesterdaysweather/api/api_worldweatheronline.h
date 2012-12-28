//
//  api_worldweatheronline.h
//  yesterdaysweather
//
//  Created by jpg on 11/27/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

//THIS IS A SINGLETON!

#import <Foundation/Foundation.h>
#import "../global_constants.h"

//http://timroadley.com/2012/02/12/core-data-basics-part-2-core-data-views/
//#import "../CoreDataTableViewController/CoreDataTableViewController.h" // so we can fetch


//DATA model header ref:
#import "../models/LastUpdate.h"

@interface api_worldweatheronline : NSObject

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, retain) LastUpdate *CoreData_lastUpdate;

//ints are not pointers:
@property(nonatomic, assign) NSInteger someNum;

//dates are
@property(nonatomic, retain) NSDate *lastPullRequest;
@property(nonatomic, retain) NSDate *currentTime;

//booleans are not...?
//@property(nonatomic, assign) Boolean cacheExpired;


//define it as a singleton:
+(api_worldweatheronline *)apiWorldWeather;

//functions:
- (void)getCities;
- (void)matchClosestCityToLatLong;
- (void)getTemperature;


@end

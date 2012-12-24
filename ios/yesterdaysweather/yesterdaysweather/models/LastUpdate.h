//
//  LastUpdate.h
//  yesterdaysweather
//
//  Created by jpg on 12/4/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LastUpdate : NSManagedObject

@property (nonatomic, retain) NSNumber * city_id;
@property (nonatomic, retain) id days;
@property (nonatomic, retain) NSDate * lastPullRequest;

@end

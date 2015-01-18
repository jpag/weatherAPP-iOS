//
//  Day.h
//  yesterdaysweather
//
//  Created by jpg on 12/28/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Day : NSManagedObject

@property (nonatomic, retain) NSNumber * city_id;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSDate * day;

@end

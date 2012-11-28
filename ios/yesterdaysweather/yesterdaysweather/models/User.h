//
//  User.h
//  yesterdaysweather
//
//  Created by jpg on 11/28/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * city_name;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSDate * lastupdate;
@property (nonatomic, retain) NSNumber * city_id;
@property (nonatomic, retain) NSNumber * useCelsius;

@end

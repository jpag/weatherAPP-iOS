//
//  User.m
//  yesterdaysweather
//
//  Created by jpg on 11/28/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import "User.h"


@implementation User

// Normally we would use @synthesize to create a backing ivar for each property and to
// make the getter and setter methods. But because this is a managed object,
// and the data lives inside a data store, Core Data will handle the
// properties another way. The @dynamic keyword tells the compiler that these
// properties will be resolved at runtime by Core Data.

@dynamic city_name;
@dynamic lat;
@dynamic lng;
@dynamic lastupdate;
@dynamic city_id;
@dynamic useCelsius;

@end

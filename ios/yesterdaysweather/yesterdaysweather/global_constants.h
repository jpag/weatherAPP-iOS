//
//  global_constants.h
//  yesterdaysweather
//
//  Created by jpg on 12/24/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#ifndef yesterdaysweather_global_constants_h
#define yesterdaysweather_global_constants_h

// 60 seconds * 60 minutes = 1 hour.
#define CACHE_EXPIRES 3600;

// URLS
//[NSURL URLWithString:@"string"]
#define URL_DOMAIN    [NSString stringWithFormat: @"http://local.weatherapp.com"];
#define PATH_CITIES   [NSString stringWithFormat: @"/api/citylist"];
#define PATH_byNAME   [NSString stringWithFormat: @"/api/city/"];
#define PATH_byID     [NSString stringWithFormat: @"/api/cityid/"];



#endif

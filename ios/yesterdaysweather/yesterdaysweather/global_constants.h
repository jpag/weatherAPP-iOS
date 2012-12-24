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
#define URL_DOMAIN   [NSURL URLWithString: @"http://local.weatherapp.com"];
#define PATH_CITIES   [NSURL URLWithString: @"/api/citylist/"];
#define PATH_byNAME   [NSURL URLWithString: @"/api/city/"];
#define PATH_byID     [NSURL URLWithString: @"/api/cityid/"];



#endif

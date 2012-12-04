//
//  api_worldweatheronline.h
//  yesterdaysweather
//
//  Created by jpg on 11/27/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

//THIS IS A SINGLETON!

#import <Foundation/Foundation.h>

@interface api_worldweatheronline : NSObject

//http://stackoverflow.com/questions/5293406/another-warning-question-incompatible-integer-to-pointer-conversion-assigning

@property(nonatomic, assign) NSInteger someNum;
//@property(nonatomic, assign) NSInteger * someNum; //would be a pointer

//define it as a singleton:
+(api_worldweatheronline *)apiWorldWeather;

//functions:
- (void)getCities;

@end

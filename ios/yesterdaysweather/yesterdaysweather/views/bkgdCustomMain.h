//
//  background.h
//  yesterdaysweather
//
//  Created by HUGE | JP Gary on 2/3/14.
//  Copyright (c) 2014 com.teamradness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bkgdCustomMain : UIView

@property(nonatomic, strong) UIColor *bkgdColor;

//-(id)initWithName:(NSString *) name locaiton:(NSString *)location date:(NSDate *) date;
-(id)initWithFrame:(CGRect)frame second:(NSDictionary *)params;

@end

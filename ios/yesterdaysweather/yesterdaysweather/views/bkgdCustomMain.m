//
//  background.m
//  yesterdaysweather
//
//  Created by HUGE | JP Gary on 2/3/14.
//  Copyright (c) 2014 com.teamradness. All rights reserved.
//

#import "bkgdCustomMain.h"

@implementation bkgdCustomMain

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //Drawing code
    //UIGraphicsGetCurrentContext();
    //UIGraphicsBeginImageContext(self.view.bounds.size);
    //UIGraphicsBeginImageContext(self.view.bounds.size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(context, 0, 0);
//    //    CGContextAddLineToPoint(context, self.view.frame.size.width, 0);
//    //    CGContextAddLineToPoint(context, self.view.frame.size.width, self.view.frame.size.height/2);
//    //    CGContextAddLineToPoint(context, 0, self.view.frame.size.height/2);
//    CGContextAddLineToPoint(context, 500, 0);
//    CGContextAddLineToPoint(context, 500,200);
//    CGContextAddLineToPoint(context, 0, 200);
//    CGContextAddLineToPoint(context, 0, 0);
//    //    CGContextSetAlpha(context, .5);
//    CGContextSetFillColorWithColor(context, col.CGColor);
//    CGContextFillPath(context);
//    
//    UIGraphicsEndImageContext();
    
    NSLog(@"hey draw RECT-----");
    
//    CGRect rectangle = CGRectMake(0, 100, 320, 100);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
//    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
//    CGContextFillRect(context, rectangle);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    CGContextSetFillColorWithColor(context, redColor.CGColor);
    CGContextFillRect(context, self.bounds);
    
}


@end

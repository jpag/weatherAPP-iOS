//
//  corelocation_gps.m
//  yesterdaysweather
//
//  Created by jpg on 10/29/13.
//  Copyright (c) 2013 com.teamradness. All rights reserved.
//

#import "corelocation_gps.h"

#define apiQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT , 0 )

@interface corelocation_gps();
@end;

@implementation corelocation_gps;


//SYNTHESIZE HERE:
@synthesize delegate;
@synthesize locationManager;

+(corelocation_gps *)corelocationGPS{
	static corelocation_gps *corelocationGPSSingleton = nil;
    
    @synchronized(self){
		NSLog(@"---- SINGLETON CREATED - GPS corelocation");
        
		if( corelocationGPSSingleton == nil ){
			corelocationGPSSingleton = [[corelocation_gps alloc] init];
            
		}
	}
	return corelocationGPSSingleton;
}

- (void)getGPS
{
    if( locationManager == nil ){
        NSLog(@"--- init locationManager");
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    NSLog(@"---- start updating location!!!!");
    
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        // longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        // latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        [delegate gpsLoaded: currentLocation];
        
    }
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
}


@end;
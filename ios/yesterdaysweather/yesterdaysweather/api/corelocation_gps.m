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
//TODO: how do I autosynthezie a delegate?
@synthesize delegate;
//@synthesize locationManager;

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
    if( _locationManager == nil ){
        NSLog(@"--- init locationManager");
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    NSLog(@"---- start updating location!!!!");
    
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    // Stop Location Manager
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        // longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        // latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        [self.delegate gpsLoaded: currentLocation];
    }
    
    // Stop Location Manager
    [_locationManager stopUpdatingLocation];
}


@end;
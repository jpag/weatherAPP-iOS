//
//  AppDelegate.h
//  yesterdaysweather
//
//  Created by jpg on 11/21/12.
//  Copyright (c) 2012 com.teamradness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) mainViewController *viewController;

//// ---- core data
//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
//@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

//
//  AppDelegate.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-21.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) LoginUser *currentUser;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

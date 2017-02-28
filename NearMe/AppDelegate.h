//
//  AppDelegate.h
//  NearMe
//
//  Created by Harshil Parikh on 2017-02-28.
//  Copyright © 2017 Harshil Parikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


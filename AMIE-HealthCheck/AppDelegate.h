//
//  AppDelegate.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)controllerDecider;

@end


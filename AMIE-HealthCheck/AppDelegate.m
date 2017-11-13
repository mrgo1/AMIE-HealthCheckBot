//
//  AppDelegate.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AppDelegate.h"
#import "AMIELexConnector.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[AMIELexConnector connector]initlizeAWSLexinteractionKit];
    [AMIEPushNotifier intilizeNotifier];
    [self controllerDecider];
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
        });
     
    }
    return YES;
}

- (void)controllerDecider
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL sstatus = [USERDEFAULT boolForKey:REGISTEREDSUCCESS];
        if (sstatus) {
            UINavigationController *nav = [STORYBOARD(@"AMIE") instantiateViewControllerWithIdentifier:@"chatHome"];
            self.window.rootViewController = nav;
            
        }else
        {
            AMIELoginVC *login = [STORYBOARD(@"AMIE") instantiateViewControllerWithIdentifier:@"AMIELoginVC"];
            self.window.rootViewController = login;
        }
        [self.window makeKeyWindow]; 
    });
   
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Notification deelgates
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[AMIEPushNotifier intilizeNotifier] registerToken:deviceToken];
    
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error %@",err);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[AMIEPushNotifier intilizeNotifier]application:application didReceiveRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[AMIEPushNotifier intilizeNotifier]application:application didReceiveRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
//    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    [[AMIEPushNotifier intilizeNotifier]application:[UIApplication sharedApplication] didReceiveRemoteNotification:notification.request.content.userInfo];
//    if (@available(iOS 10.0, *)) {
//        completionHandler(UNNotificationPresentationOptionAlert);
//    }
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    [[AMIEPushNotifier intilizeNotifier]application:[UIApplication sharedApplication] didReceiveRemoteNotification:response.notification.request.content.userInfo];
    
}

@end

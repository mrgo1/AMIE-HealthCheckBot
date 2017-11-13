//
//  AMIEPushNotifier.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 11/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AMIEPushNotifier.h"



@implementation AMIEPushNotifier
+ (AMIEPushNotifier *)intilizeNotifier
{
    static AMIEPushNotifier *notifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notifier = [AMIEPushNotifier new];
        [FIRApp configure];
        [FIRMessaging messaging].delegate = notifier;
        [notifier registerForPushNotification];
    });
    return notifier;
}
- (void)registerForPushNotification
{
    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
    NSLog(@"FCM registration token: %@", fcmToken);
    [USERDEFAULT setObject:fcmToken != nil ?fcmToken : @"" forKey:FCMTOKEN];
    USERSYNC;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        
        if (@available(iOS 10.0,*)) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = APPDELEGATE;
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
        }
        
#endif
    }
  [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerToken:(NSData *)deviceTokenData
{
    NSString *token = [[deviceTokenData description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    [USERDEFAULT setObject:token forKey:DEVICETOKEN];
    USERSYNC;
    [FIRMessaging messaging].APNSToken = deviceTokenData;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"user info : %@", userInfo[kGCMMessageIDKey]);
        [[NSNotificationCenter defaultCenter]postNotificationName:RECEIVEMESSAGEKEY object:userInfo];
    }

    NSLog(@"%@", userInfo);
}
- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    
    NSLog(@"FCM registration token: %@", fcmToken);
    [USERDEFAULT setObject:fcmToken != nil ? fcmToken : @"" forKey:FCMTOKEN];
    USERSYNC;
    
}





@end

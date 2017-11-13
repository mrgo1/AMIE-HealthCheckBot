//
//  AMIEPushNotifier.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 11/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMIEPushNotifier : NSObject<FIRMessagingDelegate>

+ (AMIEPushNotifier *)intilizeNotifier;
- (void)registerToken:(NSData *)deviceTokenData;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end

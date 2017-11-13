//
//  NetworkIntractor.h
//  MUtO
//
//  Created by Abilash Cumulations on 22/04/17.
//  Copyright © 2017 Abilash Cumulations. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id,NSURLResponse*);
typedef void(^FailureBlock)(NSError *,NSURLResponse*);

@interface NetworkIntractor : NSObject

+ (NetworkIntractor *)sharedManager;
- (void)configureSession;


//properties for newtwork manager
@property (nonatomic,strong) NSURLSession *session;


void call_getNetworkingAPI(NSString *api, SuccessBlock successBlock, FailureBlock failureBlock);

void call_PostNetworkingAPI(NSString *api, NSDictionary *param, SuccessBlock successBlock, FailureBlock failureBlock);

@end

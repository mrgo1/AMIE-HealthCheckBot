//
//  AMIELexConnector.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 04/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSLex/AWSLex.h>

typedef void(^ResponseCompletion)(JSQMessage *result);

@class JSQMessage;
@interface AMIELexConnector : NSObject<AWSLexVoiceButtonDelegate>
+ (AMIELexConnector *)connector;
- (void)initlizeAWSLexinteractionKit;
- (void)sendMessage:(MessageData *)message withCompletionBlock:(void(^)(id result))messageReturnCompletion;

- (void)sendJSQMessage:(NSString *)message withCompletionBlock:(void(^)(JSQMessage*  result))messageReturnCompletion;

@property (nonatomic,strong) AWSLexInteractionKit *interactionKit;
@property (nonatomic, strong) NSDictionary *sessionAttributes;

@property (nonatomic, strong) ResponseCompletion messageResponseCompletion;
@end

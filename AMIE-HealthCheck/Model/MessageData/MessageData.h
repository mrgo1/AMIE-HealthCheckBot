//
//  MessageData.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PlainTextMessage = 0,
    LinkMessage
}MessageType;

@interface MessageData : NSObject

@property (nonatomic,assign) MessageType messageType;
@property (assign, nonatomic) BOOL incoming;
@property (assign, nonatomic) BOOL outgoing;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) UIImage *avatharImage;

- (id)initWithMessageType:(MessageType)type withText:(NSString *)text incoming:(BOOL)incoming withLink:(NSString *)link withAvathar:(UIImage *)image;

@end

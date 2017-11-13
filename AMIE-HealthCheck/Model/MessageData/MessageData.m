//
//  MessageData.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "MessageData.h"

@implementation MessageData

- (id)initWithMessageType:(MessageType)type withText:(NSString *)text incoming:(BOOL)incoming withLink:(NSString *)link withAvathar:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.messageType = type;
        self.text = text;
        self.incoming = incoming;
        self.outgoing = !incoming;
        self.link = link;
        self.avatharImage = image;
    }
    return self;
}

@end

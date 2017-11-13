//
//  MessageBO.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 12/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "MessageBO.h"
#import "JSQMessagesTimestampFormatter.h"

@implementation MessageBO
@dynamic messageID;
@dynamic date;
@dynamic dateString;
@dynamic message;
@dynamic senderID;
@dynamic senderName;
@dynamic timeStamp;
@dynamic type;
@dynamic attrStr;

+ (void)saveMessage:(JSQMessage *)message withStatus:(void(^)(BOOL))completion
{
    
    MessageBO *msg = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                       inManagedObjectContext:[[DBHandler sharedManager] managedObjectContext]];
    msg.type = message.viewTypeName;
    msg.message = message.text;
    msg.attrStr = message.content;
    msg.senderName = message.senderDisplayName;
    msg.senderID = message.senderId;
    NSString *time = [NSString stringWithFormat:@"%@",[[JSQMessagesTimestampFormatter sharedFormatter] TimestampForDate:message.date]];
    msg.dateString = time;
    msg.date = message.date;
    NSInteger index = [USERDEFAULT integerForKey:MESSAGEINDEX];
    msg.messageID = [NSNumber numberWithInteger:index];
    [USERDEFAULT setInteger:index+1 forKey:MESSAGEINDEX];
    USERSYNC;
    msg.timeStamp = [NSString stringWithFormat:@"%@",[[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date]];
    
    [[DBHandler sharedManager]  saveContextwithStatus:^(BOOL status) {
        if (completion != nil) {
            completion(status);
        }
    }];
}


+ (MessageBO *)getMessageForID:(NSNumber *)index
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    [req setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@",index]];
    [req setReturnsObjectsAsFaults:NO];
    NSArray *arr = [[[DBHandler sharedManager] managedObjectContext] executeFetchRequest:req error:nil];
    MessageBO *result;
    if (arr.count > 0) {
        result = [arr lastObject];
    }
    return result != nil? result : nil;
}

+ (NSArray *)getMessages
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    [req setReturnsObjectsAsFaults:NO];
    NSArray *arr = [[[DBHandler sharedManager] managedObjectContext] executeFetchRequest:req error:nil];
    NSMutableArray *jsqMessages = [NSMutableArray new];
    for (MessageBO *msg in arr) {
        if ([msg.type isEqualToString:@"Call"] || [msg.type isEqualToString:@"Link"]) {
            JSQMessage *message = [[JSQMessage alloc]initWithSenderId:msg.senderID senderDisplayName:msg.senderName date:msg.date text:msg.message ViewType:msg.type content:msg.attrStr];
            [jsqMessages addObject:message];
        }else
        {
        JSQMessage *message = [[JSQMessage alloc]initWithSenderId:msg.senderID senderDisplayName:msg.senderName date:msg.date text:msg.message];
        [jsqMessages addObject:message];
        }
    }
    [jsqMessages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    return jsqMessages.count > 0 ? jsqMessages : nil;
    
}
@end


//
//  MessageBO.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 12/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MessageBO : NSManagedObject

@property (nonatomic,retain) NSNumber *messageID;
@property (nonatomic,retain) NSDate *date;
@property (nonatomic,retain) NSString *dateString;
@property (nonatomic,retain) NSString *message;
@property (nonatomic,retain) NSString *senderID;
@property (nonatomic,retain) NSString *senderName;
@property (nonatomic,retain) NSString *timeStamp;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSAttributedString *attrStr;

+ (void)saveMessage:(JSQMessage *)message withStatus:(void(^)(BOOL))completion;
+ (NSArray *)getMessages;
+ (MessageBO *)getMessageForID:(NSNumber *)index;

@end

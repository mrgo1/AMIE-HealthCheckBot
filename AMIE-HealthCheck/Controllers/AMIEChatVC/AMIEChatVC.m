//
//  AMIEChatVC.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 04/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AMIEChatVC.h"
#import "AMIELexConnector.h"
#import "JSQMessages.h"
#import "Utilities.h"

@interface AMIEChatVC ()<JSQMessagesComposerTextViewPasteDelegate>
{
     AMIEAudioView *amieAudioView;
    SuggessionsView *suggessionsView;
    NSString *appendingStr;
    BOOL isScenario1Notified;
    NSArray *lastSuggestions;
}
@property (nonatomic, strong) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation AMIEChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeView];
}
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceivePushNotificationMessage:) name:RECEIVEMESSAGEKEY object:nil];
}
- (void)initilizeView
{
    self.inputToolbar.contentView.textView.placeHolder = @"Type a message";
    self.showLoadEarlierMessagesHeader = NO;
    self.inputToolbar.contentView.textView.font = [UIFont fontWithName:@"SFCompactText-Regular" size:14];
    self.inputToolbar.contentView.textView.keyboardType = UIKeyboardTypeDefault;
    self.inputToolbar.contentView.backgroundColor = [UIColor whiteColor];
    self.messages = [NSMutableArray arrayWithArray:[MessageBO getMessages]];
    if (self.messages == nil || self.messages.count ==0) {
        self.messages = [NSMutableArray new];
    }
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    [self.inputToolbar.contentView.leftBarButtonItem setImage:[UIImage imageNamed:@"keyboardIcon"] forState:UIControlStateNormal];
    [self.inputToolbar.contentView.rightBarButtonItem setImage:[UIImage imageNamed:@"disabledSal"] forState:UIControlStateNormal];
    [self.inputToolbar.contentView.rightBarButtonItem setTitle:@"" forState:UIControlStateNormal];
   
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self.collectionView.collectionViewLayout invalidateLayout];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:NO];
    }
}
- (void)didtap
{
    if ([self.inputToolbar.contentView.textView isFirstResponder]) {
        [self.inputToolbar.contentView.textView resignFirstResponder];
    }
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    NSString *trimmedMsg = [text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if (![Utilities isDictionaryWord:trimmedMsg] && trimmedMsg.length < 10) {
        [Utilities setupAlertWithTitle:@"Alert" withButtons:@[@"Ok"] withMessga:@"Please enter correct response text" withCompletion:nil];
        return;
    }
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:trimmedMsg];
    [MessageBO saveMessage:message withStatus:^(BOOL status) {
        [self.messages addObject:message];
        appendingStr = message.text;
//        if (([[message.text lowercaseString] containsString:@"no"] || [[message.text lowercaseString] containsString:@"yes"]) && isScenario1Notified) {
//            appendingStr = [NSString stringWithFormat:@"i didn't taken %@",appendingStr];
//            if ([[message.text lowercaseString] containsString:@"yes"]) {
//                appendingStr = [NSString stringWithFormat:@"scenarioone %@",message.text];
//            }
////            NSString *msg = [SCENARIO1 stringByReplacingOccurrencesOfString:@"Good Morning Salvatore! " withString:@""];
////            appendingStr = [NSString stringWithFormat:@"%@ %@",msg,appendingStr];
//        }
//        if ([[message.text lowercaseString] containsString:@"allergies"])
//        {
//            appendingStr = @"I am facing allergies";
//        }
        
        appendingStr = [NSString stringWithFormat:@"%@ %@",message.text,MEDICATION];
        
        [[AMIELexConnector connector] sendJSQMessage:appendingStr withCompletionBlock:^(JSQMessage *result) {
            
            [self lexResponseReceived:result fromChat:true];
            
        }];
        [self finishSendingMessageAnimated:YES];
    }];
    
    
}

- (void)lexResponseReceived:(JSQMessage *)message fromChat:(BOOL)chat
{
    [self.messages addObject:message];
    [MessageBO saveMessage:message withStatus:^(BOOL status) {
    }];
    if (chat) {
        if ([message.text containsString:SIDEEFFECTS]) {
            [self didtap];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openSuggessionsView:[Utilities sideEffects]];
            });
            
        }else if ([message.text containsString:REASON]) {
            [self didtap];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openSuggessionsView:[Utilities reasonsForNotTakingMedications]];
            });
            
        }
        else if ([message.text.lowercaseString containsString:@"sorry"] && lastSuggestions.count > 0)
        {
            [self didtap];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openSuggessionsView:lastSuggestions];
            });
        }
    }
   
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.collectionView reloadData];
         [self finishSendingMessageAnimated:YES];
    });

}

- (NSString *)senderDisplayName
{
    return SenderName;
}

- (NSString *)senderId
{
    return SenderID ;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    //DO NOTHING
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    JSQMessagesAvatarImage *avatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"amie"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"sal"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];;
    }
    return avatarImage;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if(msg.hasBelowView)
    {
        cell.amieBottomContentLbl.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    }
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
    
}
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if (message.hasBelowView) {
        return 60.0f;
    }
    return 0.0;
}
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    NSString *nameWithTime = [NSString stringWithFormat:@"%@",[[JSQMessagesTimestampFormatter sharedFormatter] TimestampForDate:message.date]];
    if (![message.senderId isEqualToString:self.senderId]) {
        nameWithTime = [NSString stringWithFormat:@"%@, %@",@"Amie @ Denton Cardiology",[[JSQMessagesTimestampFormatter sharedFormatter] TimestampForDate:message.date]];
        return [[NSAttributedString alloc]initWithString:nameWithTime];
    }
    return [[NSAttributedString alloc]initWithString:nameWithTime];
    
}
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    return YES;
}

- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"Tapped accessory button!");
}


- (void)didPressAccessoryButton:(UIButton *)sender
{
    if (![self.inputToolbar.contentView.textView isFirstResponder]) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
    }else
    {
        [self.inputToolbar.contentView.textView resignFirstResponder];
    }
    
    //    [self openSuggessionsView:@[@"Migraines",@"Nausea",@"vomiting",@"Loss of appetite",@"I can't sleep",@"Heartburn"]];
}
- (void)didDismissSuggessions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (suggessionsView != nil) {
            [suggessionsView removeFromSuperview];
            suggessionsView = nil;
            [self jsq_setToolbarBottomLayoutGuideConstant:0];
        }
        if (amieAudioView != nil) {
            [amieAudioView removeFromSuperview];
            amieAudioView = nil;
            [self jsq_setToolbarBottomLayoutGuideConstant:0];
        }
    });
   
}

- (void)openSuggessionsView:(NSArray *)suggessions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (suggessionsView == nil) {
            lastSuggestions = suggessions;
            suggessionsView = [[SuggessionsView alloc]initWithSuggessions:suggessions forBaseView:self.view withCompletionBlock:^(id result) {
                [suggessionsView removeFromSuperview];
                suggessionsView = nil;
                [self jsq_setToolbarBottomLayoutGuideConstant:0];
                self.inputToolbar.contentView.textView.text = result;
                [self.inputToolbar toggleSendButtonEnabled];
                [self.inputToolbar.contentView.textView becomeFirstResponder];
            }];
            [self jsq_setToolbarBottomLayoutGuideConstant:suggessionsView.frame.size.height];
            [self.view addSubview:suggessionsView];
        }
    });
}
- (void)didReceivePushNotificationMessage:(NSNotification *)notification
{
    [self didtap];
    id value = notification.object;
    if (value != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self didDismissSuggessions];
            NSString *message;
            if ([[value valueForKeyPath:@"gcm.notification.cust_msg"]integerValue] == 1) {
                message = SCENARIO1;
                isScenario1Notified = true;
                  [self openSuggessionsView:[Utilities yesNoSuggestions]];
                 [self scrollToBottomAnimated:YES];
                
            }else if ([[value valueForKeyPath:@"gcm.notification.cust_msg"]integerValue] == 2) {
                message = SCENARIO2;
             //    [self openSuggessionsView:@[@"I’m Good",@"I’m ok"]];
                [self openSuggessionsView:[Utilities greatJobsSuggestions]];
            }else
            {
                message = SCENARIO3;
                 [self openSuggessionsView:[Utilities reasonsForNotTakingMedications]];
                 [self scrollToBottomAnimated:YES];
            }
            JSQMessage  *jsqMessage = [[JSQMessage alloc] initWithSenderId:BotName
                                                         senderDisplayName:BotName
                                                                      date:[NSDate date]
                                                                      text:message.length > 0 ? message : @"Empty message"];
            [MessageBO saveMessage:jsqMessage withStatus:^(BOOL status) {
                [self.messages addObject:jsqMessage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [self finishSendingMessageAnimated:YES];
                });

                
            }
             ];
        });
        
    }
}

- (void)clearAllChat
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MessageBO"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [[DBHandler sharedManager].persistentStoreCoordinator executeRequest:delete withContext:[DBHandler sharedManager].managedObjectContext error:&deleteError];
    if (!deleteError) {
        [self.messages removeAllObjects];
        [self.collectionView reloadData];
    }else
    {
        [Utilities setupAlertWithTitle:@"Alert" withButtons:@[@"Ok"] withMessga:@"Unable to delete, try again." withCompletion:nil];
        
    }
}


- (void)didClickOnMic:(UIButton *)sender
{
    NSLog(@"Mic icon clicked");
    [self didDismissSuggessions];
    [self didtap];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (amieAudioView == nil) {
            amieAudioView = [[AMIEAudioView alloc]initWithLEXAudioforBaseView:self.view withCompletionBlock:^(id result) {
                [self lexResponseReceived:result fromChat:false];
            }];
            [self jsq_setToolbarBottomLayoutGuideConstant:amieAudioView.frame.size.height];
            [self.view addSubview:amieAudioView];
        }
    });

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

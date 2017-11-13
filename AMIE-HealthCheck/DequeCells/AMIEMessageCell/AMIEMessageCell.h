//
//  AMIEMessageCell.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMIEMessageCell : UITableViewCell
{
    NSIndexPath *indexPath;
}
@property (strong, nonatomic) MessageData *message;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *viewBubble;
@property (strong, nonatomic) UIImageView *imageAvatar;
@property (strong, nonatomic) UILabel *labelAvatar;

- (void)messageCellSetup:(MessageData *)message withIndexPath:(NSIndexPath *)index;
- (void)layoutSubviews:(CGSize)size;
+ (CGFloat)height:(NSIndexPath *)indexPath withMessageData:(MessageData *)message;
+ (CGSize)size:(NSIndexPath *)indexPath withMessageData:(MessageData *)message;

@end

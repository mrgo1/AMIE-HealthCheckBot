//
//  AMIEMessageCell.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AMIEMessageCell.h"



@implementation AMIEMessageCell
@synthesize viewBubble;
@synthesize imageAvatar, labelAvatar,textView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)messageCellSetup:(MessageData *)message withIndexPath:(NSIndexPath *)index;
{
    self.backgroundColor = [UIColor clearColor];
    indexPath = index;
    self.message = message;
    if (viewBubble == nil)
    {
        viewBubble = [[UIView alloc] init];
        viewBubble.layer.cornerRadius = 10;
        [self.contentView addSubview:viewBubble];

    }

    CGFloat xBubble = self.message.incoming ? 5.0f : (SCREEN_WIDTH - 50);
    if (imageAvatar == nil)
    {
        imageAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(xBubble, 10, 40, 40)];
        imageAvatar.layer.masksToBounds = YES;
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width/2;
        imageAvatar.backgroundColor = [UIColor blueColor];
        imageAvatar.userInteractionEnabled = YES;
        [self.contentView addSubview:imageAvatar];
    }
    imageAvatar.image = message.avatharImage;

    if (labelAvatar == nil)
    {
        labelAvatar = [[UILabel alloc] initWithFrame:CGRectMake(self.message.incoming ? 60 : (0.6 * SCREEN_WIDTH) - 80 , 10, (0.6 * SCREEN_WIDTH) - 80, 20)];
        labelAvatar.font = [UIFont systemFontOfSize:12];
        labelAvatar.textColor = [UIColor  darkGrayColor];
        labelAvatar.textAlignment = self.message.incoming ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self.contentView addSubview:labelAvatar];
    }
    labelAvatar.text = @"Name";

    self.viewBubble.backgroundColor = message.incoming ? [UIColor colorWithRed:33/255.0f green:145/255.0f blue:253/255.f alpha:1] : [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];
    if (textView == nil)
    {
        textView = [[UITextView alloc] init];
        textView.font = [UIFont systemFontOfSize:17];
        textView.editable = NO;
        textView.selectable = NO;
        textView.scrollEnabled = NO;
        textView.userInteractionEnabled = NO;
        textView.backgroundColor = [UIColor clearColor];
        textView.textContainer.lineFragmentPadding = 0;
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [self.viewBubble addSubview:textView];
    }
    
    textView.textColor = message.incoming ? [UIColor whiteColor] : [UIColor blackColor];
    textView.text = message.text;
    
}
- (void)layoutSubviews
{
    CGSize size = [self size];
    
    [self layoutSubviews:size];
    
    textView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)layoutSubviews:(CGSize)size
{
    [super layoutSubviews];
    
    CGFloat xBubble = self.message.incoming ? 70.0f : (SCREEN_WIDTH - 70.0f - size.width);
    viewBubble.frame = CGRectMake(xBubble, 30, size.width, size.height);

}

- (CGFloat)height
{
    CGSize size = [self size];
    return size.height;
}


- (CGSize)size
{
    CGFloat maxwidth = (0.6 * SCREEN_WIDTH) - 80;
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(maxwidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat width = rect.size.width + 120;
    CGFloat height = rect.size.height + 20;
    return CGSizeMake(fmaxf(width, 45.0f), fmaxf(height, 40));
}


+ (CGFloat)height:(NSIndexPath *)indexPath withMessageData:(MessageData *)message
{
    CGSize size = [self size:indexPath withMessageData:message];
    return size.height;
}


+ (CGSize)size:(NSIndexPath *)indexPath withMessageData:(MessageData *)message
{
    CGFloat maxwidth = (0.6 * SCREEN_WIDTH) - 80;
    CGRect rect = [message.text boundingRectWithSize:CGSizeMake(maxwidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat width = rect.size.width + 120;
    CGFloat height = rect.size.height + 50;
    return CGSizeMake(fmaxf(width, 45.0f), fmaxf(height, 40));
}
@end

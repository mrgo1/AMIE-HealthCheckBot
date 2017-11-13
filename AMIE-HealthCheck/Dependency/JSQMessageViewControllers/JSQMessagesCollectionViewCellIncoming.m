//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesCollectionViewCellIncoming.h"

@implementation JSQMessagesCollectionViewCellIncoming

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageBubbleTopLabel.textAlignment = NSTextAlignmentLeft;
    self.cellBottomLabel.textAlignment = NSTextAlignmentLeft;
    [Utilities addBorder:self.amieBottomView color:[UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1] radius:0.8];
    [Utilities addBorder:self.amieTopBorderView color:[UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1] thickness:0.8 right:true left:true top:false bottom:false];
}

@end

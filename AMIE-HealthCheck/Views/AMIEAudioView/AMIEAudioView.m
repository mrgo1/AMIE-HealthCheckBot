//
//  AMIEAudioView.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 10/11/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AMIEAudioView.h"
#import "AMIELexConnector.h"

@implementation AMIEAudioView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self initializeSubviews];
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        self = arrayOfViews[0];
    }
    return self;
}

-(void)initializeSubviews {
    id view  = [[[NSBundle mainBundle]
                 loadNibNamed:NSStringFromClass([self class])
                 owner:self
                 options:nil] objectAtIndex:0];
    [self addSubview:view];
}

- (id)initWithLEXAudioforBaseView:(UIView *)baseView withCompletionBlock:(void(^)(id))completion
{
    CGRect frame = CGRectMake(0, baseView.frame.size.height-50, baseView.frame.size.width, 50);
    self = [self initWithFrame:frame];
    if (self) {
        self.lexVoiceButton.delegate = [AMIELexConnector connector];
        self.frame = CGRectMake(0, baseView.frame.size.height - 150, baseView.frame.size.width, 150);
        self.block = completion;
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [[AMIELexConnector connector] setMessageResponseCompletion:completion];
    }
    return self;
}


@end

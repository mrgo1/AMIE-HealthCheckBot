//
//  AMIEAudioView.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 10/11/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMIEAudioView : UIView
@property (nonatomic,strong) completionBlock block;
@property (weak, nonatomic) IBOutlet AWSLexVoiceButton *lexVoiceButton;

- (id)initWithLEXAudioforBaseView:(UIView *)baseView withCompletionBlock:(void(^)(id))completion;

@end

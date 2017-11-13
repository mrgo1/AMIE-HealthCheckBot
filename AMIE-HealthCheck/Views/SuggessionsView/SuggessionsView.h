//
//  SuggessionsView.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 05/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggessionsView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) completionBlock block;
- (id)initWithSuggessions:(NSArray *)dataArray forBaseView:(UIView *)baseView withCompletionBlock:(void(^)(id))completion;

@end

//
//  MeditationsView.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completionBlock)(id);
@interface MeditationsView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) completionBlock block;
- (id)initWithMeditationsDatas:(NSArray *)dataArray withBaseView:(UIView *)baseView withCompletionBlock:(void(^)(id))completion;
@end

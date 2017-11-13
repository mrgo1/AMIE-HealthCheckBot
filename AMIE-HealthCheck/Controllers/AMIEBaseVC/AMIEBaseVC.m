//
//  AMIEBaseVC.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AMIEBaseVC.h"

@interface AMIEBaseVC ()

@end

@implementation AMIEBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setNavigationTitle:(NSString *)title
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, 44)];
    [titleView addSubview:titleLb];
    titleLb.text = title;
    titleLb.font = [UIFont fontWithName:@"SFCompactText-Regular" size:20];
    titleLb.textColor = [UIColor blackColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleView;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
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

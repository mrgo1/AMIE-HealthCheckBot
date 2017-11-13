//
//  AMIEHomeVC.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AMIEHomeVC.h"
#import "Utilities.h"
#import "AMIEChatVC.h"


@interface AMIEHomeVC ()
{
    __weak IBOutlet UIView *baseView;
    AMIEChatVC *chatVC;
    MeditationsView *meditationView;
    HMSegmentedControl *SegmentControl;
    __weak IBOutlet UIBarButtonItem *clearChatBtn;
}
@end

@implementation AMIEHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeViews];
    
}

- (void)initilizeViews
{
    SegmentControl = [Utilities segmentControl:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, 40) withSegmentsArray:@[@"Medications",@"Chat",@"My Profile"]];
    [SegmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:SegmentControl];
    [self setNavigationTitle:@"Denton Cardiology"];
    [self setupChatController];
    [self setupMeditationView];
    chatVC.view.hidden = false;
    meditationView.hidden = true;
    [SegmentControl setSelectedSegmentIndex:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = clearChatBtn;
}
- (void)setupMeditationView
{
    meditationView = [[MeditationsView alloc]initWithMeditationsDatas:@[@[@"",@""],@[@"",@""]] withBaseView:baseView withCompletionBlock:^(id result) {
        
    }];
    meditationView.hidden = false;
    [baseView addSubview:meditationView];
    [Utilities stretchToSuperView:meditationView];
}
//- (void)setupChatView
//{
//    chatView = [[ChatView alloc]initWithMessages:@[] withBaseView:baseView withCompletionBlock:^(id result) {
//
//    }];
//    chatView.hidden = true;
//    [baseView addSubview:chatView];
//    [Utilities stretchToSuperView:chatView];
//}

- (void)setupChatController
{
    chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AMIEChatVC"];
    [self addChildViewController:chatVC];
    [baseView addSubview:chatVC.view];
    [chatVC didMoveToParentViewController:self];
    [Utilities stretchToSuperView:chatVC.view];
}



- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [self.view endEditing:true];
    if(segmentedControl.selectedSegmentIndex == 1)
    {
        chatVC.view.hidden = false;
        meditationView.hidden = true;
    }else
    {
           [SegmentControl setSelectedSegmentIndex:1];
    }
//    else if(segmentedControl.selectedSegmentIndex == 0)
//    {
//        chatVC.view.hidden = true;
//        meditationView.hidden = false;
//    }
}
- (IBAction)didClickOnClearAllChat:(id)sender {
    [chatVC clearAllChat];
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

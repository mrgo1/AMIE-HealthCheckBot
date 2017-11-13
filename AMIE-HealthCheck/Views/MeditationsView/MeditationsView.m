//
//  MeditationsView.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "MeditationsView.h"
#import "MyMedicationCell.h"
#import "NextDosageCell.h"

@interface MeditationsView()
{
    NSArray *meditationDatas;
    UIView *tableHeaderView;
    UILabel *headerLbl1,*headerLbl2,*headerLbl3;
}
@end

@implementation MeditationsView

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

- (id)initWithMeditationsDatas:(NSArray *)dataArray withBaseView:(UIView *)baseView withCompletionBlock:(void(^)(id))completion
{
    CGRect frame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height);
    self = [self initWithFrame:frame];
    if (self) {
        meditationDatas = dataArray;
        self.block = completion;
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = YES;
        [self.tableView registerNib:[UINib nibWithNibName:@"NextDosageCell" bundle:nil] forCellReuseIdentifier:@"nextCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"MyMedicationCell" bundle:nil] forCellReuseIdentifier:@"myMeditation"];
        
        [self.tableView reloadData];
        
        [self setupTableHeaderView];
    }
    return self;
}

- (void)setupTableHeaderView
{
    tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 250)];
    headerLbl1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40,  self.frame.size.width, 80)];
    headerLbl1.textAlignment = NSTextAlignmentCenter;
    headerLbl1.text = @"100%";
    headerLbl1.textColor = [UIColor darkGrayColor];
    headerLbl1.font = [UIFont boldSystemFontOfSize:30];
    [tableHeaderView addSubview:headerLbl1];
    
    headerLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 + headerLbl1.frame.size.height,  self.frame.size.width, 30)];
    headerLbl2.textColor = [UIColor lightGrayColor];
    headerLbl2.text = @"Great Job!";
    headerLbl2.textAlignment = NSTextAlignmentCenter;
    headerLbl2.font = [UIFont boldSystemFontOfSize:18];
    [tableHeaderView addSubview:headerLbl2];
    
    headerLbl3 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 60, 20 + headerLbl1.frame.size.height,  120 , 120)];
    headerLbl3.numberOfLines = 0;
    headerLbl3.textColor = [UIColor darkGrayColor];
     headerLbl3.text = @"You staying adherent to your medications";
    headerLbl3.textAlignment = NSTextAlignmentCenter;
    headerLbl3.font = [UIFont boldSystemFontOfSize:12];
    [tableHeaderView addSubview:headerLbl3];
    self.tableView.tableHeaderView = tableHeaderView;
    
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *aray = meditationDatas[section];
    return aray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NextDosageCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"nextCell" forIndexPath:indexPath];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Cell;
    }else
    {
        MyMedicationCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"myMeditation" forIndexPath:indexPath];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return Cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    if (section == 0) {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.frame.size.width - 50, 30)];
        lbl.text = @"YOUR NEXT DOSAGE";
        lbl.font = [UIFont boldSystemFontOfSize:13];
        lbl.textColor = [UIColor darkGrayColor];
        [headerView addSubview:lbl];
    }else
    {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.frame.size.width - 50, 30)];
        lbl.text = @"MY MEDICATIONS";
        lbl.font = [UIFont boldSystemFontOfSize:13];
        lbl.textColor = [UIColor darkGrayColor];
        [headerView addSubview:lbl];
    }
    return headerView;
}

@end

//
//  NextDosageCell.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextDosageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *todayLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitlleLbl;

@end

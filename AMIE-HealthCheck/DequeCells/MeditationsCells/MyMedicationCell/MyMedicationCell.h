//
//  MyMedicationCell.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMedicationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *moreDetailLbl;
@property (weak, nonatomic) IBOutlet UIButton *rightArrow;

@end

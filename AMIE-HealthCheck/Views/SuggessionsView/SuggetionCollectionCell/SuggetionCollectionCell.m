//
//  SuggetionCollectionCell.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 05/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "SuggetionCollectionCell.h"

@implementation SuggetionCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 0.6f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}


@end

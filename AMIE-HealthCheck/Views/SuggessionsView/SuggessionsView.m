//
//  SuggessionsView.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 05/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "SuggessionsView.h"
#import "SuggetionCollectionCell.h"

@interface SuggessionsView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray *Suggessions;
}
@end

@implementation SuggessionsView

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

- (id)initWithSuggessions:(NSArray *)dataArray forBaseView:(UIView *)baseView withCompletionBlock:(void(^)(id))completion
{
    CGRect frame = CGRectMake(0, baseView.frame.size.height-50, baseView.frame.size.width, 50);
    self = [self initWithFrame:frame];
    if (self) {
        Suggessions = dataArray;
        CGFloat count = 0;
        if (Suggessions.count % 2 == 0) {
            count = Suggessions.count/2;
        }else
        {
            count = Suggessions.count/2 +1;
        }
        self.frame = CGRectMake(0, baseView.frame.size.height-50 * count, baseView.frame.size.width, 50 * count);
        self.block = completion;
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
        [self.collectionView registerNib:[UINib nibWithNibName:@"SuggetionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        
    }
    return self;
}

#pragma mark - Collection view delegate and datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return Suggessions.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SuggetionCollectionCell *Cell   = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Cell.suggesionTextLbl.text = Suggessions[indexPath.row];
    return Cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block != nil) {
        self.block(Suggessions[indexPath.row]);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width/2, 50);
}

@end

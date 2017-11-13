//
//  Utilities.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+ (HMSegmentedControl *)segmentControl:(CGRect)frame withSegmentsArray:(NSArray *)segments
{
    // Segmented control with scrolling
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:segments];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl.frame = frame;
    segmentedControl.selectionIndicatorColor = [UIColor darkGrayColor];
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = [UIColor clearColor];
    segmentedControl.verticalDividerWidth = 1.0f;
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor],NSFontAttributeName : [UIFont fontWithName:@"SFCompactText-Regular" size:15]}];
        return attString;
    }];
   
    return segmentedControl;
}

+ (void) stretchToSuperView:(UIView*) view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSString *formatTemplate = @"%@:|[view]|";
    for (NSString * axis in @[@"H",@"V"]) {
        NSString * format = [NSString stringWithFormat:formatTemplate,axis];
        NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:bindings];
        [view.superview addConstraints:constraints];
    }
    
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void)setupAlertWithTitle:(NSString *)title withButtons:(NSArray *)data  withMessga:(NSString *)message withCompletion:(void(^)(NSString *))completion
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    for (NSString *item in data) {
        [alertVC addAction:[UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion != nil) {
             completion(item);
            }

            [alertVC dismissViewControllerAnimated:true completion:nil];
        }]];
    }
    
    [[APPDELEGATE window].rootViewController presentViewController:alertVC animated:true completion:nil];
    
    
}

+ (void)showLoader
{
    [APPDELEGATE window].userInteractionEnabled = false;
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setRingRadius:30];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor blackColor]];
    [SVProgressHUD show];
    
}

+ (void)hideLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
        [APPDELEGATE window].userInteractionEnabled = true;
    });
    
}

+(void)applyShadowOnView:(CALayer *)layer OffsetX:(CGFloat)x OffsetY:(CGFloat)y blur:(CGFloat)radius opacity:(CGFloat)alpha RoundingCorners:(CGFloat)cornerRadius{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:cornerRadius];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(x,y);// shadow x and y
    layer.shadowOpacity = alpha;
    layer.shadowRadius = radius;// blur effect
    layer.shadowPath = shadowPath.CGPath;
}
+ (void)addShadow:(UIView *)view
{
//    view.layer.masksToBounds = NO;
//    view.layer.shadowOffset = CGSizeMake(1.0, 1.0);
//    view.layer.shadowRadius = 0.5;
//    view.layer.shadowOpacity = 0.5;
    float shadowSize = 10.0f;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(view.frame.origin.x - shadowSize / 2,
                                                                           view.frame.origin.y - shadowSize / 2,
                                                                           view.frame.size.width + shadowSize,
                                                                           view.frame.size.height + shadowSize)];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
   view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
   view.layer.shadowOpacity = 0.8f;
    view.layer.shadowPath = shadowPath.CGPath;
}


+ (NSAttributedString *)AtrialFibrillation
{
    NSString *content = @"Atrial Fibrillation\nAtrial fibrillation(also AFib or AF) is a quivering or i...";
    NSRange boldrange= NSMakeRange(0, 19);
    
   UIFont *font=[UIFont fontWithName:@"SFCompactText-Semibold" size:11];

    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:content];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:boldrange];
      [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} range:NSMakeRange(0, [content length])];
    return attributedString;
}

+ (NSAttributedString *)HeartFailure
{
    NSString *content = @"Heart Failure\nHeart failure occurs when the heart muscle is weak...";
    NSRange boldrange= NSMakeRange(0, 13);
    
    UIFont *font=[UIFont fontWithName:@"SFCompactText-Semibold" size:11];
    
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:content];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:boldrange];
    NSRange boldrange1= NSMakeRange(13 ,[content length]-13);
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"SFCompactText-Regular" size:9]                             range:boldrange1];
    [attributedString addAttributes:@{NSLinkAttributeName: [NSURL URLWithString:@"http://www.heart.org/HEARTORG/Conditions/HeartFailure/Heart-Failure_UCM_002019_SubHomePage.jsp"],NSForegroundColorAttributeName: [UIColor blackColor],NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSUnderlineColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, [content length])];
 
    return attributedString;
}

+ (NSAttributedString *)CustomerCare
{
    NSString *content = @"CLICK HERE TO CALL\nOr dial 555-555-5555 to call\nDr. Caldwell's office";
    NSRange boldrange= NSMakeRange(0, 17);
     NSRange boldrange1= NSMakeRange(17 ,[content length]-17);
    UIFont *font=[UIFont fontWithName:@"SFCompactText-Semibold" size:11];
    
    
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:content];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:boldrange];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"SFCompactText-Regular" size:9]
                             range:boldrange1];
    [attributedString addAttributes:@{NSLinkAttributeName: [NSURL URLWithString:@"708-557-2960"],NSForegroundColorAttributeName: [UIColor blackColor],NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSUnderlineColorAttributeName:[UIColor clearColor]}
                              range:NSMakeRange(0, [content length])];
   

    return attributedString;
}
+ (NSAttributedString *)MoreInformation
{
    NSString *content = @"CLICK HERE TO CALL\n1-888-ENTRESTO\nOr visit www.entresto.com";
    NSRange boldrange= NSMakeRange(0, 17);
    
    UIFont *font=[UIFont fontWithName:@"SFCompactText-Semibold" size:11];
    
    
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:content];
    
    NSRange boldrange1= NSMakeRange(17 ,[content length]-17);
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"SFCompactText-Regular" size:9]                             range:boldrange1];
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:boldrange];
    [attributedString addAttributes:@{NSLinkAttributeName: [NSURL URLWithString:@"1-888-368-7378"],NSForegroundColorAttributeName: [UIColor blackColor],NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSUnderlineColorAttributeName:[UIColor clearColor]}
                              range:NSMakeRange(0, [content length])];
//     [attributedString addAttributes:@{NSLinkAttributeName: [NSURL URLWithString:@"http://www.entresto.com"]} range:NSMakeRange(33, 25)];

    return attributedString;
}

+ (void)addCornerRadius:(UIView *)view withRectCorners:(UIRectCorner)corners
{
//    UIView *roundedView = view;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10.0, 10.0)];
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = roundedView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    roundedView.layer.mask = maskLayer;
}

+ (void)addBorder:(UIView *)view color:(UIColor *)color radius:(CGFloat)radius
{
    view.clipsToBounds = true;
    [view.layer setBorderColor: color.CGColor];
    [view.layer setBorderWidth: radius];
    [view.layer setCornerRadius:10];
}
+ (void)addBorder:(UIView *)view color:(UIColor *)color thickness:(CGFloat)thickness right:(BOOL)right left:(BOOL)left top:(BOOL)top bottom:(BOOL)bottom
{
    if (top) {
        UIView *topBorder = [UIView new];
        topBorder.backgroundColor = color;
        topBorder.frame = CGRectMake(0, 0, view.frame.size.width, thickness);
        [view addSubview:topBorder];
    }
    if (bottom) {
        UIView *bottomBorder = [UIView new];
        bottomBorder.backgroundColor = color;
        bottomBorder.frame = CGRectMake(0, view.frame.size.height - thickness, view.frame.size.width, thickness);
        [view addSubview:bottomBorder];
    }
    if (left) {
        UIView *leftBorder = [UIView new];
        leftBorder.backgroundColor = color;
        leftBorder.frame = CGRectMake(0, 0, thickness, view.frame.size.height);
        [view addSubview:leftBorder];
    }
    if (right) {
        UIView *border = [UIView new];
        border.backgroundColor = color;
        [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
        border.frame = CGRectMake(view.frame.size.width - thickness, 0, thickness, view.frame.size.height);
        [view addSubview:border];
    }
}

+ (void)openApplicationWithURL:(NSString *)urlstr
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlstr]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
    }
    
}

+ (BOOL)isDictionaryWord:(NSString*)word {
    UITextChecker *checker = [[UITextChecker alloc] init];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *currentLanguage = [currentLocale objectForKey:NSLocaleLanguageCode];
    NSRange searchRange = NSMakeRange(0, [word length]);
    
    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:word range:searchRange startingAt:0 wrap:NO language:currentLanguage];
    return misspelledRange.location == NSNotFound;
}
+ (NSString *)getActualText:(NSString *)message
{
    message = [message stringByReplacingOccurrencesOfString:@"That s" withString:@"That's"];
    message = [message stringByReplacingOccurrencesOfString:@"It s" withString:@"It's"];
    message = [message stringByReplacingOccurrencesOfString:@"you re" withString:@"you’re"];
    message = [message stringByReplacingOccurrencesOfString:@"Caldwell s" withString:@"Caldwell's"];
    return message;
}

+ (NSArray *)reasonsForNotTakingMedications
{
    return  @[@"Allergies/Intolerance",@"Personal preference",@"It's too expensive",@"I am / planning to become pregnant",@"I saw an ad that concerned me",@"I'm experiencing side effects"];
}

+ (NSArray *)greatJobsSuggestions
{
    return @[@"It makes me feel better",@"My healthcare provider prescribed it",@"I saw a favorable television advertisement",@"It may reduce my need to be hospitalized",@"It may reduce the need for additional heart failure medications",@"Entresto may reduce my risk of death from heart failure"];
}
+ (NSArray *)yesNoSuggestions
{
    return @[@"Yes",@"No"];
}

+ (NSArray *)sideEffects
{
    return @[@"Migraines",@"Cough",@"Dizziness",@"Diarrhea",@"Fatigue",@"Back Pain"];
}
@end

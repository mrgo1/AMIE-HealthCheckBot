//
//  Utilities.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 03/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+ (HMSegmentedControl *)segmentControl:(CGRect)frame withSegmentsArray:(NSArray *)segments;
+ (void) stretchToSuperView:(UIView*) view;
+ (BOOL)validateEmailWithString:(NSString*)email;
+ (void)setupAlertWithTitle:(NSString *)title withButtons:(NSArray *)data  withMessga:(NSString *)message withCompletion:(void(^)(NSString *))completion;
+ (void)showLoader;
+ (void)hideLoader;
+ (void)addShadow:(UIView *)view;
+(void)applyShadowOnView:(CALayer *)layer OffsetX:(CGFloat)x OffsetY:(CGFloat)y blur:(CGFloat)radius opacity:(CGFloat)alpha RoundingCorners:(CGFloat)cornerRadius;
+ (void)addCornerRadius:(UIView *)view withRectCorners:(UIRectCorner)corners;
+ (void)addBorder:(UIView *)view color:(UIColor *)color radius:(CGFloat)radius;
+ (void)addBorder:(UIView *)view color:(UIColor *)color thickness:(CGFloat)thickness right:(BOOL)right left:(BOOL)left top:(BOOL)top bottom:(BOOL)bottom;

+ (void)openApplicationWithURL:(NSString *)urlstr;
+ (NSString *)getActualText:(NSString *)message;

//Attribiute
+ (NSAttributedString *)AtrialFibrillation;
+ (NSAttributedString *)CustomerCare;
+ (NSAttributedString *)HeartFailure;
+ (NSAttributedString *)MoreInformation;

+ (NSArray *)reasonsForNotTakingMedications;
+ (NSArray *)greatJobsSuggestions;
+ (NSArray *)yesNoSuggestions;
+ (NSArray *)sideEffects;

+ (BOOL)isDictionaryWord:(NSString*)word;
@end

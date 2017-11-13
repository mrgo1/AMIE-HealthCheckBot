//
//  AMIELoginVC.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 11/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AMIELoginVC.h"

@interface AMIELoginVC ()<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *emailField;
    
    __weak IBOutlet UIButton *signinBtn;
}
@end

@implementation AMIELoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didClickOnSigninButton:(id)sender
{
    [self.view endEditing:true];
    if ([Utilities validateEmailWithString:emailField.text]) {
        [Utilities showLoader];
        call_PostNetworkingAPI(REGISTRATIONAPI, @{@"email":emailField.text}, ^(id JSON, NSURLResponse *response) {
            NSLog(@"JSON  === %@",JSON);
            if ([[JSON valueForKey:statusKey] isEqualToString:SUCCESS]) {
                NSString *userId = [[JSON valueForKey:recordsKey]valueForKey:user_idKey];
                [USERDEFAULT setObject:userId forKey:USERID];
                USERSYNC;
                [self sendDeviceToken];
            }
        }, ^(NSError *error, NSURLResponse *response) {
            NSLog(@"error  === %@",error.localizedFailureReason);
            [Utilities setupAlertWithTitle:@"Alert" withButtons:@[@"Ok"] withMessga:error.localizedFailureReason withCompletion:nil];
            [Utilities hideLoader];
        });
        
        
    }else
    {
        [Utilities setupAlertWithTitle:@"Alert" withButtons:@[@"Ok"] withMessga:@"Please enter valid email id" withCompletion:nil];
        
    }
}

- (void)sendDeviceToken
{
    NSString *userId = [USERDEFAULT objectForKey:USERID];
    NSString *token = [USERDEFAULT objectForKey:FCMTOKEN];
    
    NSDictionary *param = @{@"user_id":userId,
                            @"device_token":token
                            };
    call_PostNetworkingAPI(FCM_TOKENAPI, param, ^(id JSON, NSURLResponse *response) {
        NSLog(@"JSON  === %@",JSON);
        [Utilities hideLoader];
        if ([[JSON valueForKey:statusKey] isEqualToString:SUCCESS]) {
            BOOL registrationStatus = [[JSON valueForKey:resultKey]boolValue];
            [USERDEFAULT setBool:registrationStatus forKey:REGISTEREDSUCCESS];
            USERSYNC;
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [APPDELEGATE controllerDecider];
        });
        
    }, ^(NSError *error, NSURLResponse *response) {
        NSLog(@"error  === %@",error.localizedFailureReason);
        [Utilities setupAlertWithTitle:@"Alert" withButtons:@[@"Ok"] withMessga:error.localizedFailureReason withCompletion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [APPDELEGATE controllerDecider];
        });
    });
    
}

#pragma mark - TEXTFIELD DELEGATE
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
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

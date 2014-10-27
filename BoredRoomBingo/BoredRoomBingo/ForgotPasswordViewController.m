//  ForgotPasswordViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/25/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//
#import "ForgotPasswordViewController.h"
#import "config.h"
#import <FacebookSDK/FacebookSDK.h>
@implementation ForgotPasswordViewController
-(void)viewDidLoad {
    [super viewDidLoad];
   // [self logInFacebookUser];
}
- (IBAction)sendEmailPressed:(UIButton *)sender {
    [self backgroundTouch:nil];
    if (![self validateEmail:self.emailTextField.text] ) {
        [self invalidEmail];
    } else {
        [self sendEmail];
    }
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
-(void)sendEmail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref resetPasswordForUser:self.emailTextField.text withCompletionBlock:^(NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ErrorMessage *errorAlert = [[ErrorMessage alloc]init];
            [errorAlert errorMessages:error];
        } else {
            // Password reset sent successfully
            hud.labelText = @"Sending Email";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *emailSent = [[UIAlertView alloc] initWithTitle:@"Email Sent!" message:@"Check your email and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [emailSent addButtonWithTitle:@"OK"];
            [emailSent show];
        }
    }];
}
-(void)invalidEmail {
    UIAlertView *invalidEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Email!" message:@"Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [invalidEmail addButtonWithTitle:@"OK"];
    [invalidEmail show];
}
- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"OK Tapped. Hello World!");
    }
}
- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES];
}

@end

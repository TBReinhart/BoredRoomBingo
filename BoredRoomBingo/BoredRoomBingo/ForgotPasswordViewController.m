//  ForgotPasswordViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/25/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//
#import "ForgotPasswordViewController.h"
#import "config.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginSignUp.h"
@implementation ForgotPasswordViewController
-(void)viewDidLoad {
    [super viewDidLoad];
   // [self logInFacebookUser];
}
- (IBAction)sendEmailPressed:(UIButton *)sender {
    [self backgroundTouch:nil];
    [self sendEmail];
}
/**
 Sends email to reset password.
 */
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
/**
 If email is invalid, will prompt message.
 */
-(void)invalidEmail {
    UIAlertView *invalidEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Email!" message:@"Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [invalidEmail addButtonWithTitle:@"OK"];
    [invalidEmail show];
}

/**
 Hides keyboard when background touched.
 */
- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES];
}

@end

//
//  SignUpViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/20/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "SignUpViewController.h"
#import <Firebase/Firebase.h>
#import "config.h"
#import "ErrorMessage.h"
@implementation SignUpViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}
-(IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES];
}

-(IBAction)registerUser:(id)sender{
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        UIAlertView *passwordsNotEqualAlert = [[UIAlertView alloc] initWithTitle:@"Passwords Don't Match!" message:@"Please match your passwords" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [passwordsNotEqualAlert addButtonWithTitle:@"OK"];
        [passwordsNotEqualAlert show];
        return;
    }
    
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref createUser:self.emailTextField.text password:self.passwordTextField.text
withCompletionBlock:^(NSError *error) {
    
    if (error) {
        // There was an error creating the account
        NSLog(@"error %@", error);
        ErrorMessage *errorAlert = [[ErrorMessage alloc]init];
        [errorAlert errorMessages:error];
        return;
    } else {
        NSLog(@"created acct");
        // We created a new user account
    }
}];
}




@end

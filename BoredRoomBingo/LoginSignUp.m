//
//  LoginSignUp.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/24/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "LoginSignUp.h"
#import <Firebase/Firebase.h>
#import "config.h"
@implementation LoginSignUp

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.emailView setHidden:YES];
    [self.optionsView setHidden:NO];
}
- (IBAction)emailPressed:(UIButton *)sender {
    [self.optionsView setHidden:YES];
    [self.emailView setHidden:NO];
}
- (IBAction)backPressed:(id)sender {
    [self.optionsView setHidden:NO];
    [self.emailView setHidden:YES];
    [self.emailTextField setText:@""];
}
- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES];
}

// TODO if user exists try logging in, else register them
- (IBAction)nextPressed:(UIButton *)sender {
    if (![self validateEmail:self.emailTextField.text]) {
        UIAlertView *invalidEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Email!" message:@"Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [invalidEmail addButtonWithTitle:@"OK"];
        [invalidEmail show];
        return;
    }
    if ([self.passwordTextField.text length] < 6) {
        UIAlertView *invalidPassword = [[UIAlertView alloc] initWithTitle:@"Password Not Long Enough!" message:@"Must be at least 6 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [invalidPassword addButtonWithTitle:@"OK"];
        [invalidPassword show];
        return;
    }
    
    NSString *tentativeUsername = [self.emailTextField.text componentsSeparatedByString:@"@"][0];
    NSLog(@"tentative is %@", tentativeUsername);
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref authUser:self.emailTextField.text password:self.passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        // if password was invalid, but email wasn't. user exists but screwed up
        if (error.code == FAuthenticationErrorInvalidPassword) {
            NSLog(@"invalid password"); // password invalid or acct taken
        } else if (error.code == FAuthenticationErrorUserDoesNotExist) {
            UIAlertView *askToMakeAccount = [[UIAlertView alloc] initWithTitle:@"Email Available!" message:@"create new account?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [askToMakeAccount addButtonWithTitle:@"Create"];
            [askToMakeAccount show];
        } else {
            [self displayError:error];
        }
        // an error occurred while attempting login
    } else {
        NSLog(@"AUTH %@", authData);
        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    }
    }];
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    } else if (buttonIndex == 1) {
        NSLog(@"Create Tapped");
        [self createNewAccount];
    }
}
-(void)createNewAccount {
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref createUser:self.emailTextField.text password:self.passwordTextField.text
withCompletionBlock:^(NSError *error) {
    if (error) {
        // There was an error creating the account
        [self displayError:error];
    } else {
        // firebase doesn't log in after creating
        [self standardLogin];
    }
}];
}
-(void)displayError: (NSError *)error {
    ErrorMessage *errorAlert = [[ErrorMessage alloc]init];
    [errorAlert errorMessages:error];
}
-(void)standardLogin {
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref authUser:self.emailTextField.text password:self.passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error ) {
        [self displayError:error];
    } else {
        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    }
}];
}
//    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
//    [ref createUser:self.emailTextField.text password:self.passwordTextField.text
//withCompletionBlock:^(NSError *error) {
//    
//    if (error.code == FAuthenticationErrorEmailTaken) { // email taken try log in
//        NSLog(@"error is %@", error);
//        NSLog(@"code is %@", )
//        // There was an error creating the account
//    } else {
//        // We created a new user account
//    }
//}];
    
    //NSString *userProfilePictureURL = [NSString stringWithFormat:@"%@users/%@",FIREBASE_URL,self.usernameTextField.text];
//    Firebase* firebaseRef = [[Firebase alloc] initWithUrl:userProfilePictureURL];
//    Firebase *usersRef = [firebaseRef childByAppendingPath: @"profilePicture"];
//    NSDictionary *profilePicture = @{@"profilePicture": imageString};
    //[usersRef setValue:profilePicture];


// catlan stackOF
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
@end

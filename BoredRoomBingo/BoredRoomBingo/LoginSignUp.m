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
#import "MBProgressHUD.h"

#import <FacebookSDK/FacebookSDK.h>
@implementation LoginSignUp
-(void)viewDidLoad {
    [super viewDidLoad];
    [self.emailView setHidden:YES];
    [self.optionsView setHidden:NO];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    if (myUsername != nil) {
        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    }
    
}
- (IBAction)emailPressed:(UIButton *)sender {
    [self.optionsView setHidden:YES];
    [self.emailView setHidden:NO];
}
- (IBAction)backPressed:(id)sender {
    [self.optionsView setHidden:NO];
    [self.emailView setHidden:YES];
    [self.emailTextField setText:@""];
    [self.passwordTextField setText:@""];
}
- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)nextPressed:(UIButton *)sender {
    if (![self checkFields]) { return; }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref authUser:self.emailTextField.text password:self.passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    } else {
        NSLog(@"AUTH %@", authData);
        [self setUserPrefs:authData];
        //[self postInitialUser];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    }
    }];
}
-(BOOL)checkFields {
    if (![self validateEmail:self.emailTextField.text]) {
        UIAlertView *invalidEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Email!" message:@"Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [invalidEmail addButtonWithTitle:@"OK"];
        [invalidEmail show];
        return NO;
    }
    else if ([self.passwordTextField.text length] < 6) {
        UIAlertView *invalidPassword = [[UIAlertView alloc] initWithTitle:@"Password Not Long Enough!" message:@"Must be at least 6 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [invalidPassword addButtonWithTitle:@"OK"];
        [invalidPassword show];
        return NO;
    } else {
        return YES;
    }
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
        // firebase doesn't log in after creating... so have to log in now
        [self postInitialUser];
        [self standardLogin];
    }
}];
}


-(void)displayError: (NSError *)error {
    ErrorMessage *errorAlert = [[ErrorMessage alloc]init];
    [errorAlert errorMessages:error];
}
/**
 TODO: throw up some javadocs bro
 */
-(void)standardLogin {
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref authUser:self.emailTextField.text password:self.passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error ) {
        [self displayError:error];
    } else {
        [self setUserPrefs:authData];
        // [self postInitialUser];
        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    }
}];
}
-(void)setUserPrefs: (FAuthData *)authData {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.emailTextField.text forKey:@"email"];
    NSString *usernameOfID = [self parseString:authData.uid];
    [prefs setObject:usernameOfID forKey:@"username"]; // for now username is unique id
    [prefs setObject:authData.token forKey:@"authToken"];
    [prefs synchronize];
}
-(NSString *)parseString:(NSString *)mySimpleLogin {
    NSArray *myWords = [mySimpleLogin componentsSeparatedByCharactersInSet:
                        [NSCharacterSet characterSetWithCharactersInString:@":"]
                        ];
    return [NSString stringWithFormat:@"user%@",myWords[1]];
}

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
-(void)postInitialUser {
    NSDictionary *userData = @{ @"email": self.emailTextField.text };
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@users", FIREBASE_URL]];
    //Firebase *usersRef = [ref childByAppendingPath: @"users"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    Firebase *newUserRef = [ref childByAppendingPath:[prefs stringForKey:@"username"]];
    [newUserRef setValue: userData];
}


@end

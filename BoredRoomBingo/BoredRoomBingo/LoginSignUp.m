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

/**
 Sets up view controller and if logged in already segues you to home screen
 */
-(void)viewDidLoad {
    [super viewDidLoad];
    [self.myFacebookView setHidden:YES];
    [self.emailView setHidden:YES];
    [self.optionsView setHidden:NO];
    self.passwordTextField.delegate = self;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    if (myUsername != nil) {
        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    }
    
}
/**
 Choose email as means of signing in
 */
- (IBAction)emailPressed:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Sign Up With Email"]) {
        [self.usernameTextField setHidden:NO];
        [self.forgotPasswordButton setHidden:YES];
        
    } else {
        // when logging in allow users to press forgot password.
        [self.usernameTextField setHidden:YES];
        [self.forgotPasswordButton setHidden:NO];
    }
    [self.optionsView setHidden:YES];
    [self.emailView setHidden:NO];
}
/**
 When return is pressed when typing password, will call submit button.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self submitPressed:nil];
    return NO;
}
/**
 Return to menu of login options.
 */
- (IBAction)backPressed:(id)sender {
    [self.usernameTextField setHidden:YES];
    [self.optionsView setHidden:NO];
    [self.emailView setHidden:YES];
    [self.emailTextField setText:@""];
    [self.passwordTextField setText:@""];
}
/**
 Ends editing with keyboard.
 */
- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES];
}
/**
 User Submits login/signup credentials.
 */
- (IBAction)submitPressed:(UIButton *)sender {
    // if username is hidden, that means we are just logging in.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Signing In";
    [sender setEnabled:NO];

    if ([self.usernameTextField isHidden]) {
        
        [self standardLogin:self.emailTextField.text withPassword:self.passwordTextField.text withCreated:NO];
    } else { // else they are creating account.
        [self verifyCreateUser];
        // loads all usernames, if unique calls create account
        // if create successful with call standard login
    }
    [sender setEnabled:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
/**
 Create new account.
 Will be called after checking to make sure username is not taken.
 */
-(void)createAccount:(NSString *)email withPassword:(NSString *)password withUsername:(NSString *)username {
    Firebase *createAccountRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@",FIREBASE_URL]];
    [createAccountRef createUser:email password:password
withCompletionBlock:^(NSError *error) {
    
    if (error) {
        [self displayError:error];
    } else {
        // We created a new user account
        // now set their initial data and then
        [self standardLogin:email withPassword:password withCreated:YES];
    }
}];
}
/**
 Standard login.
 Will be called for a normal login including after account creation
 Will use data to set user defaults.
 */
-(void)standardLogin:(NSString *)email withPassword:(NSString *)password withCreated:(BOOL)justCreated {
    Firebase *loginRef = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [loginRef authUser:email password:password
   withCompletionBlock:^(NSError *error, FAuthData *authData) {
       if (error ) {
           [self displayError:error];
       } else {
           // logged in and now have permission to set firebase data.
           if (justCreated) {
               // need to set data before getting data.
               [self setFireBaseUserDictionary:email withID:[NSString stringWithFormat:@"%@", authData.uid] withUsername:self.usernameTextField.text];
           } else {
               // simply get the data.
               [self getDefaultsFromFirebase:[NSString stringWithFormat:@"%@", authData.uid]];
           }
       }
   }];
}
/**
 Get user dictionary to set device defaults
 Only called on existing users
 */
-(void)getDefaultsFromFirebase:(NSString *)uniqueID {
    // Get a reference to our posts
    Firebase *ref = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"%@users",FIREBASE_URL]];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *myUserID = [uniqueID componentsSeparatedByCharactersInSet:
                             [NSCharacterSet characterSetWithCharactersInString:@":"]
                             ];
        NSString *userWithID = [NSString stringWithFormat:@"user%@",myUserID[1]];
        for (NSString *user in snapshot.value) {
            if ([user isEqualToString:userWithID]) {
                [self setUserPrefs:snapshot.value[user][@"email"] withUsername:snapshot.value[user][@"username"] withUserID:userWithID];
            }
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}
/**
 Set firebase dictionary
 only called upon creation since it won't exist yet.
 */
-(void)setFireBaseUserDictionary:(NSString *)email withID:(NSString *)uniqueID withUsername:(NSString *)username {
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@users",FIREBASE_URL]];
    NSDictionary *user = @{@"email":email, @"username":username};
    NSArray *myUserID = [uniqueID componentsSeparatedByCharactersInSet:
                        [NSCharacterSet characterSetWithCharactersInString:@":"]
                        ];
    NSString *userWithID = [NSString stringWithFormat:@"user%@",myUserID[1]];
    Firebase *newUserRef = [ref childByAppendingPath:userWithID];
    [newUserRef setValue:user];
    [self setUserPrefs:email withUsername:username withUserID:userWithID];

}
/**
 Set user tokens depending on firebase preferences
 Segues wince the last thing to do is set preferences
 */
-(void)setUserPrefs:(NSString *)email withUsername:(NSString *)username withUserID:(NSString *)userID {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:email forKey:@"email"];
    [prefs setObject:userID forKey:@"userID"]; // for now username is unique id
    [prefs setObject:username forKey:@"username"]; // for now username is unique id
    // TODO: check valid username strings . $ # [ ] /
    [prefs synchronize];
    [self.emailTextField setText:@""];
    [self.usernameTextField setText: @""];
    [self.passwordTextField setText:@""];
    [self performSegueWithIdentifier:@"loggedIn" sender:nil];
}
/**
 Checks fields for login/sign up are valid and will give errors if not correct.
 Checks if password is @ least 6 characters.
 Checks if email passes regex.
 */
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
/**
 Get All usernames to check new user against
 Will be called at every submit in case somebody creates an account while this user is signing up.
 If username is unique, will call create account.
 */
-(void)verifyCreateUser {
    if ([self.usernameTextField.text length] < 1) {
        UIAlertView *noUsername = [[UIAlertView alloc] initWithTitle:@"No Username!" message:@"You need a username to register." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noUsername show];
        return;
    }
    
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@users",FIREBASE_URL];
    Firebase *gameRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    [gameRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
            NSMutableArray *allUsers = [[NSMutableArray alloc]init];
            for (NSDictionary *user in snapshot.value) {
                [allUsers addObject:snapshot.value[user][@"username"]];
            }
            // if username is taken flash an alert and don't proceed with sign up process.
            if ([allUsers containsObject:self.usernameTextField.text]) {
                UIAlertView *usernameTaken = [[UIAlertView alloc] initWithTitle:@"Username Unavailable!" message:@"Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [usernameTaken show];
                return;
            } else {
                [self createAccount:self.emailTextField.text withPassword:self.passwordTextField.text withUsername:self.usernameTextField.text];
                return;
            }
        } else {
            // first user
            [self createAccount:self.emailTextField.text withPassword:self.passwordTextField.text withUsername:self.usernameTextField.text];
        }
    }];
}

/**
 Display error message
 */
-(void)displayError: (NSError *)error {
    ErrorMessage *errorAlert = [[ErrorMessage alloc]init];
    [errorAlert errorMessages:error];
}

/**
 catlan stackOF
 http://stackoverflow.com/questions/800123/what-are-best-practices-for-validating-email-addresses-in-objective-c-for-ios-2/1149894#1149894
 a regular expression that regulates what user emails can create.
 WILL accept crazy emails !matt$=awesome@mail.aol.biz
*/
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
/**
 Allows mobility to move back to login screen.
 */
- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue {
    //nothing goes here
}

@end

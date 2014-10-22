//
//  LoginViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "LoginViewController.h"
#import <Firebase/Firebase.h>
#import "config.h"
@interface LoginViewController ()

// The Firebase object
@property (nonatomic, strong) Firebase *ref;
// The simpleLogin object that is used to authenticate against Firebase

// The user currently authenticed with Firebase
@property (nonatomic, strong) FAuthData *currentUser;


@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}



-(IBAction)submitPressed:(id)sender
{
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref authUser:self.emailField.text password:self.passwordField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
    if (error) {
        NSLog(@"error");
        NSLog(@"%@", ref.authData);
        // an error occurred while attempting login
    } else {
        // user is logged in, check authData for data
        NSLog(@"logged in");
    }
}];

}

-(IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//
//-(void)logInStandardUser {
//    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
//    [ref authUser:@"treinhart4115@gmail.com" password:@"password"
//
////    [ref authUser:self.emailField.text password:self.passwordField.text
//withCompletionBlock:^(NSError *error, FAuthData *authData) {
//    
//    if (error) {
//        // There was an error logging in to this account
//        NSLog(@"Log in unsuccessful");
//    } else {
//        // We are now logged in
//        NSLog(@"Log in Successful :)");
//        NSLog(@"auth data %@" , authData);
//    }
//}];
//}




- (IBAction)submitButtonPressed:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"logged in :)");
   // [self performSegueWithIdentifier:@"login" sender:nil];
    
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

//
//  LoginSignUp.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/24/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Firebase/Firebase.h>
/**
  The view controller for selecting whether logging in or signing up manually or with social network.
 */
@interface LoginSignUp : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *emailView; ///< The view for selecting email login/signup
@property (strong, nonatomic) IBOutlet UIView *optionsView; ///< The view for selecting which login/signup
@property (strong, nonatomic) IBOutlet UITextField *emailTextField; ///< The field where users enter email
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField; ///< The field where users enter his/her password
- (BOOL) validateEmail: (NSString *) candidate;
-(void)standardLogin:(NSString *)email withPassword:(NSString *)password withCreated:(BOOL)justCreated;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField; ///< Username prompt for first time users.
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton; ///< Button that allows users to reset password when loggin in.
@property (strong, nonatomic) IBOutlet FBLoginView *myFacebookView;
- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue;
@end

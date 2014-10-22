//
//  LoginViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface LoginViewController : UIViewController <UITextViewDelegate>

@property (strong,nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;


@end

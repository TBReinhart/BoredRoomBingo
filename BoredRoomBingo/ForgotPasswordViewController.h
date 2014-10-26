//
//  ForgotPasswordViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/25/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *sendEmailButton;

@end

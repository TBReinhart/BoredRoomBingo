//
//  ForgotPasswordViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/25/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
  The view controller to help users send a password reset.
 */
@interface ForgotPasswordViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTextField; ///< The field where user enters email
@property (strong, nonatomic) IBOutlet UIButton *sendEmailButton; ///< The button that sends password reset
@end

//
//  ErrorMessage.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/21/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "ErrorMessage.h"
#import <Firebase/Firebase.h>
@implementation ErrorMessage


-(void)errorMessages:(NSError*)error {
    // an error occurred while attempting login
    NSString *errorTitle;
    NSString *errorMessage;
    NSLog(@"error code is %ld", (long)error.code);
    switch(error.code) {
        case FAuthenticationErrorEmailTaken:
            errorTitle = @"Email Taken!";
            errorMessage = @"Please enter a new email.";
            break;
        case FAuthenticationErrorUserDoesNotExist:
            // Handle invalid user
            errorTitle = @"User Does Not Exist!";
            errorMessage = @"Please try again.";
            break;
        case FAuthenticationErrorInvalidEmail:
            // Handle invalid email
            errorTitle = @"Invalid Email!";
            errorMessage = @"Please try again.";
            break;
        case FAuthenticationErrorNetworkError:
            errorTitle = @"Network Error!";
            errorMessage = @"Please connect to the network, and try again.";
            break;
        case FAuthenticationErrorInvalidPassword:
            // Handle invalid password
            errorTitle = @"Invalid Password";
            errorMessage = @"Please try again.";
            break;
        default:
            errorTitle = @"Learning Opportunity!";
            errorMessage = @"Don't worry it will be fixed soon! \nFixing Problems is part of our DNA!";
            break;
    }
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [errorAlert addButtonWithTitle:@"OK"];
    [errorAlert show];
}

@end

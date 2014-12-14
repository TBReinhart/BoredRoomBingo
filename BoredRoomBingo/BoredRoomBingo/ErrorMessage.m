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


/**
 These errors are the only errors which can occur during the project, and
 */

-(void)errorMessages:(NSError*)error {
    LoginError *newError;
    NSLog(@"error is %@", error);
    switch(error.code) {
        case FAuthenticationErrorEmailTaken:
            newError = [[EmailTakenError alloc]  initEmailTakenError];
            break;
        case FAuthenticationErrorUserDoesNotExist:
            // Handle invalid user
            newError = [[UserDoesNotExistError alloc] initUserDoesNotExistError];
            break;
        case FAuthenticationErrorInvalidEmail:
            // Handle invalid email
            newError = [[InvalidEmailError alloc] initInvalidEmailError];
            break;
        case FAuthenticationErrorNetworkError:
            newError = [[NetworkError alloc] initNetworkError];
            break;
        case FAuthenticationErrorInvalidPassword:
            // Handle invalid password
            newError = [[InvalidPasswordError alloc] initIvalidPasswordError];
            break;
        default:
            newError = [[DefaultError alloc] initDefaultError];
            break;
    }
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[newError getErrorTitle] message:[newError getErrorData] delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [errorAlert addButtonWithTitle:@"OK"];
    [errorAlert show];
}

@end

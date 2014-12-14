//
//  UserDoesNotExistError.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "UserDoesNotExistError.h"

/**
 error to be called when a user does not exist
 */
@implementation UserDoesNotExistError

/**
 constructor for user does not exist error.
 */
-(instancetype)initUserDoesNotExistError {
    self.errorTitle = @"User Does Not Exist!";
    self.errorData = @"Please try again.";
    return self;
}

@end

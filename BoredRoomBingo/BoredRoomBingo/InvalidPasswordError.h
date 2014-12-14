//
//  InvalidPasswordError.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "LoginError.h"

/**
 Error to be thrown when an invalid pssowrd is specified.
 */
@interface InvalidPasswordError : LoginError

/**
 Constructor for the invalid password error.
 */
-(instancetype)initIvalidPasswordError;

@end

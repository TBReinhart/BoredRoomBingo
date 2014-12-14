//
//  InvalidEmailError.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "LoginError.h"

/**
 Class which defines an invalid email error. 
 */
@interface InvalidEmailError : LoginError

/**
 Constructor for the invalid email error.
 */
-(instancetype)initInvalidEmailError;
@end

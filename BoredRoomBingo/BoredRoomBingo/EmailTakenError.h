//
//  EmailTakenError.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "LoginError.h"

/**
 Error to be used if an email is already taken.
 */
@interface EmailTakenError : LoginError


/**
 Constructor for the email taken error.
 */
-(instancetype)initEmailTakenError;

@end

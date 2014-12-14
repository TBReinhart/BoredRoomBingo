//
//  DefaultError.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "LoginError.h"
/**
 Generic error message for login errors.
 */
@interface DefaultError : LoginError

/**
 Constructor for the default login errors from firebase.
 */
-(instancetype)initDefaultError;
@end

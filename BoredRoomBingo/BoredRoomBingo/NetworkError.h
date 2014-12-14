//
//  NetworkError.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "LoginError.h"


/**
 constructor for invalid network errors
 */
@interface NetworkError : LoginError


/**
 Error to be thrown when there is a network error logging in.
 */
-(instancetype)initNetworkError;

@end

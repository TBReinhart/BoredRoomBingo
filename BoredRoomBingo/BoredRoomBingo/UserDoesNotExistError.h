//
//  UserDoesNotExistError.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "LoginError.h"

@interface UserDoesNotExistError : LoginError


-(instancetype)initUserDoesNotExistError;
@end

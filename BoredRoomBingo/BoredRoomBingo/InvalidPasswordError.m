//
//  InvalidPasswordError.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "InvalidPasswordError.h"

@implementation InvalidPasswordError

-(instancetype)initIvalidPasswordError {
    self.errorTitle = @"Invalid Password";
    self.errorData = @"Please try again.";
    return self;
}

@end

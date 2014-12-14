//
//  InvalidEmailError.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "InvalidEmailError.h"

@implementation InvalidEmailError

-(instancetype)initInvalidEmailError{
    self.errorTitle = @"User Does Not Exist!";
    self.errorData = @"Please try again.";
    return self;
}
@end

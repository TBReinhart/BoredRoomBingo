//
//  EmailTakenError.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "EmailTakenError.h"


@implementation EmailTakenError


-(instancetype)initEmailTakenError {
    self.errorTitle = @"Email Taken!";
    self.errorData = @"Please enter a new email.";
    return self;
}
@end

//
//  NetworkError.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "NetworkError.h"

@implementation NetworkError


-(instancetype)initNetworkError{
    self.errorTitle = @"Network Error!";
    self.errorData = @"Please connect to the network, and try again.";
    return self;
}

@end


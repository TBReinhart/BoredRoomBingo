//
//  InviteFriendModel.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "InviteFriendModel.h"

@implementation InviteFriendModel

-(instancetype)initInviteModel:(NSMutableArray *)friendsList {
    self.friends = friendsList;
    return self;
}

@end

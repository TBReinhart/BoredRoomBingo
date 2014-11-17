//
//  InviteFriendModel.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteFriendModel : NSObject
-(instancetype)initInviteModel:(NSMutableArray *)userList;
@property (nonatomic, strong) NSMutableArray *users; ///< List of all users.

@end

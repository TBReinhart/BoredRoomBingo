//
//  SearchUsersTableViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchUsersTableViewController : UITableViewController
-(void)setUserList:(NSMutableArray *)list withFriendsList:(NSMutableArray *)friends;

@end

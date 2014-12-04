//
//  SearchUsersTableViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 View Controller to search all users for potential invites to game 
 */
@interface SearchUsersTableViewController : UITableViewController
-(void)setUserList:(NSMutableArray *)list withUserIDs:(NSMutableArray *)userIDs;
-(void)setGameKey:(NSString *)key;
-(void)setGameName:(NSString *)gameName;
-(void)setActiveGame:(BOOL)active;
@end

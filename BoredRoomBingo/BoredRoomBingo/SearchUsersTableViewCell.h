//
//  SearchUsersTableViewCell.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 Cell class for a user where a game creator can invite a user to the game
 */
@interface SearchUsersTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel; ///< Username label returned in search
@property (strong, nonatomic) IBOutlet UIButton *addRemoveButton; ///< button to send an invitation to username in same cell
@end

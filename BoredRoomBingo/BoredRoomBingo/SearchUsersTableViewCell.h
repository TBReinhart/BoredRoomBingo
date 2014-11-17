//
//  SearchUsersTableViewCell.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchUsersTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *addRemoveButton;
@property (strong, nonatomic) IBOutlet UILabel *friendLabel;

@end

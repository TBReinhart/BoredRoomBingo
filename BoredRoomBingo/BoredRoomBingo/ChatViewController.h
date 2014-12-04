//
//  ChatViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/24/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
/**
 The View Controller that controls the chat system within each game. 
 Users can freely chat during a game to all others in the game.
 BASED ON FIRECHAT example provided by FIREBASE backend
 https://github.com/firebase/firechat-ios
 */
@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) NSString* username; ///< username from message
@property (nonatomic, strong) NSMutableArray* chat; ///< array of all chat messages to be displayed
@property (nonatomic, strong) Firebase* firebase; ///< Firebase reference
@property (nonatomic, strong) NSString *url; ///< url for the game

@property (weak, nonatomic) IBOutlet UITextField *messageTextField; ///< text field for composing
@property (weak, nonatomic) IBOutlet UITableView *chatTableView; /// table view for all chat messages

@end

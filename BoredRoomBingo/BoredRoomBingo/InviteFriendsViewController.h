//
//  InviteFriendsViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic,strong) NSString *gameKey; ///< Key of Game to send to users
@property (nonatomic,strong) NSString *gameName; ///< Name of game to send to users
@property (strong, nonatomic) IBOutlet UITextField *searchFriendsTextField;
@end

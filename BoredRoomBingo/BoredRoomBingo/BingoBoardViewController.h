//
//  BingoBoardViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 View and controller for the bingo board where we play the game.
 */
@interface BingoBoardViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *boardButton; ///< Collection of all board buttons.
@property (nonatomic,strong) NSMutableArray *boardWords; ///< Array containing all words on board.
@property (nonatomic,strong) NSString *gameKey; ///< Unique game id where game is hosted from firebase.

@property (strong, nonatomic) IBOutlet UIImageView *bingoCelebrationImage;
@property (strong, nonatomic) IBOutlet UIView *gameOverView;

@end

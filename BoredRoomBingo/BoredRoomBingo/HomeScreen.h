//
//  HomeScreen.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/27/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivedWordListsTableViewController.h"
/**
 This is the intro screen for setting up a game which displays selecting an existing list or adding current words.
 */
@interface HomeScreen : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *groupNameTextField; ///< Group Name of Game.
@property (strong, nonatomic) IBOutlet UITextField *addNewWordTextField; ///< Text field to add a new word to game.
@property (strong, nonatomic) IBOutlet UITextField *listNameTextField; ///< Text field to name your current list as new list.
@property (strong, nonatomic) IBOutlet UISwitch *privatePublicSwitch; ///< Switch to set game to public or private.
@property (nonatomic,strong) NSMutableArray *currentWords; ///< Array of all current words for game.
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *backgroundTap; ///< Tap registered when clicking board used for clearing keyboard.
-(void)setList:(NSString *)list;
-(void)addToCurrentWords:(NSMutableArray *)wordsToAdd; 
@property (strong, nonatomic) NSMutableArray *arrayWithWordsToAdd; ///< Array of words to add from a selected list.
- (IBAction)unwindToHomeScreen:(UIStoryboardSegue *)segue; ///< Unwind segue for future view controllers to get back to home screen.
@end

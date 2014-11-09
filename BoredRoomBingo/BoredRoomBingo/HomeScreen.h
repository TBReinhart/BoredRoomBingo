//
//  HomeScreen.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/27/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivedWordListsTableViewController.h"
@interface HomeScreen : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addNewWordTextField;
@property (strong, nonatomic) IBOutlet UITextField *listNameTextField;
@property (strong, nonatomic) IBOutlet UISwitch *privatePublicSwitch;
@property (nonatomic,strong) NSMutableArray *currentWords;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *backgroundTap;
-(void)setList:(NSString *)list;
-(void)addToCurrentWords:(NSMutableArray *)wordsToAdd;
@property (strong, nonatomic) NSMutableArray *arrayWithWordsToAdd;
- (IBAction)unwindToHomeScreen:(UIStoryboardSegue *)segue;
@end

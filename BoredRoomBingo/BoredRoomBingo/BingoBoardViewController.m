//
//  BingoBoardViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "BingoBoardViewController.h"
#import "BoardModel.h"
#import "config.h"
#import "ChatViewController.h"
#import <Parse/Parse.h>
#import <AudioToolbox/AudioToolbox.h>
@interface BingoBoardViewController ()
{
    BoardModel *model;
    NSString *creator;
    NSMutableArray *savedWords;
    NSMutableArray *savedValues;
}
@end

@implementation BingoBoardViewController
/**
 Initialize bingo board
 */
- (void)viewDidLoad {
//[self.gameOverView setHidden:YES];
    [self setTextSize];
    [super viewDidLoad];
    [self.checkWinnersBoardButton setHidden:YES];
    [self.confirmButton setHidden:YES];
    [self.denyButton setHidden:YES];
    ChatViewController *chat = (ChatViewController *)self.childViewControllers[0];
    [chat reloadInputViews];
    [self loadFirebase];
    [self checkForOtherGameOvers];
    
}
/**
 Sets text size to fit.
 */
-(void)setTextSize {
    self.getNewBoardButton.titleLabel.numberOfLines = 1;
    self.getNewBoardButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.getNewBoardButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.checkWinnersBoardButton.titleLabel.numberOfLines = 1;
    self.checkWinnersBoardButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.checkWinnersBoardButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
}
/**
 Loads specific firebase with values of game.
 */
-(void)loadFirebase {
    NSString *gameKeyUrl = [NSString stringWithFormat:@"%@",self.gameKey];
    Firebase *gameRef = [[Firebase alloc] initWithUrl: gameKeyUrl];
    [gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
            NSMutableArray *fullList = [[NSMutableArray alloc]init];
            for (NSString *word in snapshot.value[@"list"]) {
                [fullList addObject:word];
            }
            creator = snapshot.value[@"creator"];
            [self.navigationItem setTitle:snapshot.value[@"gameName"]];
            if (model == nil) {
                [self setUp:fullList];
            }

        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}
-(void)setUp:(NSMutableArray *)fullList {
    model = [[BoardModel alloc]initBoardModel:self.gameKey withFullList:fullList];
    [self setUpBoardButton];
}
/**
 Set up board buttons with proper text format and titles
 */
-(void)setUpBoardButton {
    NSInteger counter = 0;
    NSMutableArray *randomList = model.randomList;
    NSLog(@"randomList %@", model.randomList);
    for (UIButton *button in self.boardButton) {
        button.tag = counter;
        NSString *title = randomList[counter];
        [button setTitle:[NSString stringWithFormat:@"%zd",counter] forState:UIControlStateNormal];

        //[button setTitle:title forState:UIControlStateNormal];
        NSLog(@"#:%zd:%@",counter,title);
        counter++;
        button.titleLabel.minimumScaleFactor= 5./button.titleLabel.font.pointSize;
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.layer.borderWidth = 3.0f;
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.layer.cornerRadius = 10.0f;
        [button.titleLabel setTextAlignment: NSTextAlignmentCenter];
        
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.lineBreakMode = NSLineBreakByClipping;

    }
}
/**
 Swaps betweeen the current board state and the words specified in args
 saves old words locally
 */
-(void)swapBoard:(NSMutableArray *)words withValues:(NSMutableArray *)values {
    if (savedValues == nil) {
        savedValues = [[NSMutableArray alloc]init];
        savedWords = [[NSMutableArray alloc]init];
    }
    int counter = 0;
    for (UIButton *button in self.boardButton) {
        [savedWords addObject:button.titleLabel.text];
        [savedValues addObject:[NSString stringWithFormat:@"%zd",!button.enabled]]; // !
        [button setTitle:[words objectAtIndex:counter] forState:UIControlStateNormal];
        if ([[NSString stringWithFormat:@"%@",[values objectAtIndex:counter]] isEqualToString:@"0"]) {
            [button setEnabled:YES];
            [button setBackgroundColor:[UIColor colorWithRed:(206.0/255.0) green:(206.0/255.0) blue:(206.0/255.0) alpha:1]];
        } else {
            [button setBackgroundColor:[UIColor orangeColor]];
            [button setEnabled:NO];
        }
        counter++;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 Disable button on click and notify model.
 */
-(IBAction)boardButtonPressed:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor orangeColor]];
    NSLog(@"sender tag:%zd", sender.tag);
    sender.layer.borderWidth = 3.0f;
    sender.layer.borderColor = [UIColor clearColor].CGColor;
    sender.layer.cornerRadius = 10.0f;
    [sender setAlpha:30];
    [sender setEnabled:NO];
    // freespace should be at index 12.
    NSInteger index = [sender tag];

    NSInteger row = index/5;
    NSInteger column = index % 5;
    [model wordToggledatLocation:row withColumn:column];
    if ([model checkForWin]) {
        [self gameOver];
    }
}
/**
 Determine if create account was tapped or if cancel tapped.
 */
- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 Alert that game was won!
 */
-(void)gameOver {
    [self endGameForOthers];
    [self sendWinningNotification];
}
/**
 Set user as winner in firebase
 */
-(void)setMeAsWinner {
    NSString *makeMeWinnerUrl = [NSString stringWithFormat:@"%@/winner",self.gameKey];
    Firebase *ref = [[Firebase alloc]initWithUrl:makeMeWinnerUrl];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    [ref setValue:myUsername];
}
/**
 Check if i'm still winner
 */
-(void)checkIfIAmStillWinner {
    
    NSString *amIWinnerUrl = [NSString stringWithFormat:@"%@",self.gameKey];
    Firebase *ref = [[Firebase alloc]initWithUrl:amIWinnerUrl];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value[@"winner"] != [NSNull null] && [snapshot.value[@"winner"] isEqualToString:myUsername] && !snapshot.value[@"winningBoard"]) {
            [self playAgainPressed:nil];
            NSString *oldWinnerUrl = [NSString stringWithFormat:@"%@/winner",self.gameKey];
            Firebase *oldWinner = [[Firebase alloc]initWithUrl:oldWinnerUrl];
            [oldWinner setValue:@""];
            [self.getNewBoardButton setHidden:NO];
            
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}
/**
 Send notice that the game is over.
 */
-(void)endGameForOthers {
    NSString *changeActiveUrl = [NSString stringWithFormat:@"%@/winningBoard",self.gameKey];
    Firebase *ref = [[Firebase alloc] initWithUrl:changeActiveUrl];
    NSMutableArray *labels;
    NSMutableArray *clicked;
    if (labels == nil) {
        labels = [[NSMutableArray alloc]init];
        clicked = [[NSMutableArray alloc]init];
    } else {
        [labels removeAllObjects];
        [clicked removeAllObjects];
    }
    for (UIButton *button in self.boardButton) {
        [labels addObject:button.titleLabel.text];
        [clicked addObject:[NSNumber numberWithBool:!button.enabled]];
    }
    
    NSDictionary *active = @{@"labels":labels, @"clicked":clicked};
    
    [ref setValue:active];
    [self.getNewBoardButton setHidden:YES];
    [self setMeAsWinner];
    [self checkIfIAmStillWinner];
}
/**
 Checks for gameover. will notify others when game is over.
 */
-(void)checkForOtherGameOvers {
    NSString *isGameOverYetUrl = [NSString stringWithFormat:@"%@/winningBoard",self.gameKey];
    Firebase *ref = [[Firebase alloc]initWithUrl:isGameOverYetUrl];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // snapshot.value will only exist if someone has won the game, if someone has
        // denied the game, delete it
        if (snapshot.value != [NSNull null]) {
            [self.checkWinnersBoardButton setHidden:NO];
        } else {
            [self.checkWinnersBoardButton setHidden:YES];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}
/**
 Send an alert that you just won to everyone in the game!
 */
-(void)sendWinningNotification {
    // Send a notification to all devices subscribed to the "Giants" channel.
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:creator];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    NSString *message = [NSString stringWithFormat:@"Game Over!\n%@ Won!",myUsername];
    [push setMessage:message];
    [push sendPushInBackground];
}
/**
 Send an alert to let people know game is still on
 */
-(void)sendGameOnNotification {
    PFPush *push = [[PFPush alloc]init];
    [push setChannel:creator];
    NSString *message = [NSString stringWithFormat:@"The winner is a fraud!\n Game on!"];
    [push setMessage:message];
    [push sendPushInBackground];
}
/** send to child */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embeddedChat"]) {
        ChatViewController *chat = [segue destinationViewController];
        [chat setUrl:self.gameKey];
    }
}
-(IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
/**
 Check if winners board is legit
 gives option to confirm or deny
 */
- (IBAction)checkWinnersBoardPressed:(UIButton *)sender {
    NSString *winningBoardCheckUrl = [NSString stringWithFormat:@"%@/winningBoard",self.gameKey];
    Firebase *ref = [[Firebase alloc]initWithUrl:winningBoardCheckUrl];
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSMutableArray *clicked = snapshot.value[@"clicked"];
        NSMutableArray *labels = snapshot.value[@"labels"];
        [self swapBoard:labels withValues:clicked];
        [self.getNewBoardButton setHidden:YES];
        [self.confirmButton setHidden:NO];
        [self.denyButton setHidden:NO];
        [self.checkWinnersBoardButton setHidden:YES];
    }];
}
/**
 Deny and tell all!
 */
-(IBAction)denyPressed:(id)sender {
    [self hideConfirmDeny];
    [self.checkWinnersBoardButton setHidden:YES];
    NSString *destroyWinnerUrl = [NSString stringWithFormat:@"%@/winningBoard",self.gameKey];
    Firebase *ref = [[Firebase alloc]initWithUrl:destroyWinnerUrl];
    [ref removeValue];
    [self sendGameOnNotification];
    
}
/**
 Confirm hides
 */
-(IBAction)confirmPressed:(id)sender {
    [self hideConfirmDeny];
}
/**
 hide buttons and swap
 */
-(void)hideConfirmDeny {
    [self.confirmButton setHidden:YES];
    [self.denyButton setHidden:YES];
    [self.checkWinnersBoardButton setHidden:NO];
    [self.getNewBoardButton setHidden:NO];
    NSLog(@"checked: %@", savedValues);
    [self swapBoard:savedWords withValues:savedValues];
}
/**
 Set up model again.
 */
-(IBAction)playAgainPressed:(id)sender {
    model = nil;
    [self loadFirebase];
    int counter = 0;
    for (UIButton *button in self.boardButton) {
        if (counter == 12) {
            [button setEnabled:NO];
            [button setBackgroundColor:[UIColor orangeColor]];
        } else {
            [button setEnabled:YES];
            [button setBackgroundColor:[UIColor colorWithRed:(206.0/255.0) green:(206.0/255.0) blue:(206.0/255.0) alpha:1]];
        }
        counter++;
    }
}
@end

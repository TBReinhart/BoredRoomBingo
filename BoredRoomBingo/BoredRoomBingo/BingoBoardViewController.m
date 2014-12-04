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
}
@end

@implementation BingoBoardViewController
/**
 Initialize bingo board
 */
- (void)viewDidLoad {
    [self.gameOverView setHidden:YES];
    [super viewDidLoad];
    ChatViewController *chat = (ChatViewController *)self.childViewControllers[0];
    [chat reloadInputViews];
    [self loadFirebase];
    [self checkForOtherGameOvers];
    

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
            model = [[BoardModel alloc]initBoardModel:self.gameKey withFullList:fullList];
            [self setUpBoardButton];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}
/**
 Set up board buttons with proper text format and titles
 */
-(void)setUpBoardButton {
    NSInteger counter = 0;
    NSMutableArray *randomList = model.randomList;
    for (UIButton *button in self.boardButton) {
        button.tag = counter;
        NSString *title = randomList[counter];
        [button setTitle:title forState:UIControlStateNormal];
        counter++;
        button.titleLabel.minimumScaleFactor= 5./button.titleLabel.font.pointSize;
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.layer.borderWidth = 3.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.cornerRadius = 10.0f;
        [button.titleLabel setTextAlignment: NSTextAlignmentCenter];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 Disable button on click and notify model.
 */
-(IBAction)boardButtonPressed:(id)sender {
    [sender setBackgroundColor:[UIColor orangeColor]];
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
   // self.bingoCelebrationImage.image = [UIImage imageNamed:@"bingo.png"];
    [self endGameForOthers];
    [self sendWinningNotification];
}
/**
 Send notice that the game is over.
 */
-(void)endGameForOthers {
    NSString *changeActiveUrl = [NSString stringWithFormat:@"%@/active",self.gameKey];
    Firebase *ref = [[Firebase alloc] initWithUrl:changeActiveUrl];
    [ref setValue:@"over"];
}
/**
 Checks for gameover. will notify others when game is over.
 */
-(void)checkForOtherGameOvers {
    NSString *isGameOverYetUrl = [NSString stringWithFormat:@"%@/active",self.gameKey];
    Firebase *ref = [[Firebase alloc]initWithUrl:isGameOverYetUrl];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null] && [snapshot.value isEqualToString:@"over"]) {
            NSLog(@"game over!! ");
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            //[self.gameOverView setHidden:NO];
            //Firebase *removeRef = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"%@",self.gameKey]];
            //[removeRef removeValue];
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
/** send to child */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embeddedChat"]) {
        ChatViewController *chat = [segue destinationViewController];
        [chat setUrl:self.gameKey];
    }
}
@end

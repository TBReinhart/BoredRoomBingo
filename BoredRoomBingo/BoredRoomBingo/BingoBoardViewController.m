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
@interface BingoBoardViewController ()
{
    BoardModel *model;
}
@end

@implementation BingoBoardViewController
/**
 Initialize bingo board
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFirebase];
    

}
-(void)loadFirebase {
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@",self.gameKey];
    NSLog(@"url is %@", wordlistUrl);
    Firebase *gameRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    [gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
            NSMutableArray *fullList = [[NSMutableArray alloc]init];
            for (NSString *word in snapshot.value[@"list"]) {
                [fullList addObject:word];
            }
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
    UIAlertView *winAlert = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:@"Someone won the game!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [winAlert addButtonWithTitle:@"Ok!"];
    [winAlert show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

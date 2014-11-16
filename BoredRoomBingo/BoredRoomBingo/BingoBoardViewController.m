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
    model = [[BoardModel alloc]initBoardModel:self.gameKey];
    NSLog(@"model gamekey is %@", self.gameKey);

    
    [self setUpBoardButton];
}

/**
 Set up board buttons with proper text format and titles
 */
-(void)setUpBoardButton {
    NSInteger counter = 0;
    NSMutableArray *randomList = [model getRandomList];
    for (UIButton *button in self.boardButton) {
        button.tag = counter;
        NSString *title = randomList[counter];
        [button setTitle:title forState:UIControlStateNormal];
        counter++;
        button.titleLabel.minimumScaleFactor= 5./button.titleLabel.font.pointSize;
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
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
    [sender setAlpha:30];
    [sender setEnabled:NO];
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

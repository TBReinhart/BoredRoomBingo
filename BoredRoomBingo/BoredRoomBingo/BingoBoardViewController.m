//
//  BingoBoardViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "BingoBoardViewController.h"
#import "config.h"
@interface BingoBoardViewController ()
{
    NSMutableArray *randomList;
}
@end

@implementation BingoBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"list %@", self.boardWords);
    [self selectBoardWords];
    // Do any additional setup after loading the view.
    
}
-(void)selectBoardWords {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@",self.gameKey];
    NSLog(@"word list %@", wordlistUrl);
    Firebase *postsRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    [postsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            randomList = [[NSMutableArray alloc]init];
            for (NSString *word in snapshot.value[@"list"]) {
                [randomList addObject:word];
            }
            self.navigationItem.title = snapshot.value[@"gameName"];
            [self setUpBoardButton];
        }
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];

}
-(void)setUpBoardButton {
    NSInteger counter = 0;
    for (UIButton *square in self.boardButton) {
        square.tag = counter;
        [square setTitle:randomList[counter] forState:UIControlStateNormal];
        counter++;
        square.titleLabel.minimumScaleFactor= 5./square.titleLabel.font.pointSize;
        square.titleLabel.numberOfLines = 1;
        square.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

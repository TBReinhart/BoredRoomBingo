//
//  PublicGamesTableViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/14/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "PublicGamesTableViewController.h"
#import "BingoBoardViewController.h"
#import "config.h"
@interface PublicGamesTableViewController ()
{
    NSMutableArray *publicGameList;
    NSMutableArray *gameKeys;
}
@end

@implementation PublicGamesTableViewController
/**
 Set navigation title and loads game names
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Public Games";
    [self loadGameNames];

}
/**
 Load all public games from firebase.
 */
- (void)loadGameNames {
    NSString *gamelistUrl = [NSString stringWithFormat:@"%@game/public",FIREBASE_URL];
    Firebase *postsRef = [[Firebase alloc] initWithUrl: gamelistUrl];
    [postsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            publicGameList = [[NSMutableArray alloc]init];
            gameKeys = [[NSMutableArray alloc]init];
            for (id game in snapshot.value) {
                NSString *key = [NSString stringWithFormat:@"%@",game];
                NSString *gameUrl = [NSString stringWithFormat:@"%@game/public/%@",FIREBASE_URL,key];
                if ([snapshot.value[key][@"active"] isEqualToString:@"yes"]) {
                    [gameKeys addObject:gameUrl];
                    [publicGameList addObject:snapshot.value[key][@"gameName"]];
                }
            }
        }
        [self.tableView reloadData];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 1 section in tableview.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    ///< Return the number of sections.
    return 1;
}
/**
 There is one game per cell.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [publicGameList count];
}

/**
 Set each cell title with game name.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gameName" forIndexPath:indexPath];
    cell.textLabel.text = publicGameList[indexPath.row];
    
    return cell;
}

/**
 Select list to segue to list of words within selected list
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"gameSelected" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gameSelected"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        BingoBoardViewController * bingoBoard = (BingoBoardViewController *)[segue destinationViewController];
        bingoBoard.gameKey = gameKeys[path.row];
        
    }
}

@end

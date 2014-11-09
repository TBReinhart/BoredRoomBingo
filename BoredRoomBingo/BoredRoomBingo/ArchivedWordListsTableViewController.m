//
//  ArchivedWordListsTableViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/3/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "ArchivedWordListsTableViewController.h"
#import "DetailArchiveWordlistTableViewController.h"
#import "HomeScreen.h"
#import "config.h"
@interface ArchivedWordListsTableViewController ()
{
    NSMutableArray *archivedLists;
}
@end
@implementation ArchivedWordListsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    archivedLists = [[NSMutableArray alloc]init];
    [self getLists];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getLists {
    // Get a reference to our posts
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@users/%@/wordlists",FIREBASE_URL,myUsername];
    Firebase *postsRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    [postsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            [archivedLists removeAllObjects];
            for (id list in [snapshot.value allKeys]) {
                [archivedLists addObject:list];
            }
        }
        [self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [archivedLists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wordlistCell" forIndexPath:indexPath];
    cell.textLabel.minimumScaleFactor = 8./cell.textLabel.font.pointSize;
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    [[cell textLabel] setText:archivedLists[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeScreen *homeScreen = [[HomeScreen alloc]init];
    [homeScreen setList:archivedLists[indexPath.row]];
    self.listToPass = archivedLists[indexPath.row];
    [self.parentViewController performSegueWithIdentifier:@"selectListSegue" sender:self];
}


@end

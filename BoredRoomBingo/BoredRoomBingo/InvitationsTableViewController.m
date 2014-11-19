//
//  InvitationsTableViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/18/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "InvitationsTableViewController.h"
#import "config.h"
#import "InvitationTableViewCell.h"
@interface InvitationsTableViewController () <InvitationsTableViewCellDelegate>
{
    NSMutableArray *invitations;
    NSMutableArray *gameKeys;
    NSMutableArray *creators;
}
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@end

@implementation InvitationsTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInvitations];
    self.cellsCurrentlyEditing = [NSMutableArray array];
}
- (void)cellDidOpen:(UITableViewCell *)cell
{
    NSIndexPath *currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:[self.tableView indexPathForCell:cell]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadInvitations {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myID = [prefs stringForKey:@"userID"];
    NSString *invitationUrl = [NSString stringWithFormat:@"%@users/%@/invites",FIREBASE_URL,myID];
    Firebase *gameRef = [[Firebase alloc] initWithUrl: invitationUrl];
    [gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (invitations == nil) {
            invitations = [[NSMutableArray alloc]init];
            gameKeys = [[NSMutableArray alloc]init];
            creators = [[NSMutableArray alloc]init];
        } else {
            [invitations removeAllObjects];
            [gameKeys removeAllObjects];
            [creators removeAllObjects];
        }
        if (snapshot.value != [NSNull null]) {
            for (NSDictionary *invite in snapshot.value) {
                NSLog(@"invite %@, snap %@", invite, snapshot.value);
                [invitations addObject:snapshot.value[invite][@"gameName"]];
                [gameKeys addObject:snapshot.value[invite][@"gameKey"]];
                [creators addObject:snapshot.value[invite][@"creator"]];
            }
        }
        [self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [invitations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"invitationCell";
    InvitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[InvitationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.gameNameLabel setText:invitations[indexPath.row]];
    [cell.creatorLabel setText:creators[indexPath.row]];
    cell.backgroundColor = [UIColor purpleColor];
    cell.contentView.backgroundColor = [UIColor blueColor];
    cell.delegate = self;
    [cell.acceptButton setTag:indexPath.row];
    [cell.denyButton setTag:indexPath.row];
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    return cell;
}

#pragma mark - SwipeableCellDelegate
- (void)acceptActionForItemText:(NSString *)itemText {
    NSLog(@"In the delegate, Clicked button one for accept");
}

- (void)denyActionForItemText:(NSString *)itemText {
    NSLog(@"In the delegate, Clicked button two for deny");
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

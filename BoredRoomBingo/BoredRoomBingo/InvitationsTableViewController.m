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
#import "BingoBoardViewController.h"
#import "HomeScreenViewController.h"
@interface InvitationsTableViewController () <InvitationsTableViewCellDelegate>
{
    NSMutableArray *myInviteFirebase;
    NSMutableArray *invitations;
    NSMutableArray *gameKeys;
    NSMutableArray *creators;
    NSInteger acceptedTag;
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
            myInviteFirebase = [[NSMutableArray alloc]init];
        } else {
            [invitations removeAllObjects];
            [gameKeys removeAllObjects];
            [creators removeAllObjects];
            [myInviteFirebase removeAllObjects];
        }
        if (snapshot.value != [NSNull null]) {
            for (NSDictionary *invite in snapshot.value) {
                [invitations addObject:snapshot.value[invite][@"gameName"]];
                [gameKeys addObject:snapshot.value[invite][@"gameKey"]];
                [creators addObject:snapshot.value[invite][@"creator"]];
                [myInviteFirebase addObject:[NSString stringWithFormat:@"%@users/%@/invites/%@",FIREBASE_URL,myID,invite]];
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
    [cell.denyButton addTarget:self action:@selector(denyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)denyButtonPressed:(UIButton *)sender {
    NSString *denyUrl = [NSString stringWithFormat:@"%@",myInviteFirebase[[sender tag]]];
    Firebase *denyRef = [[Firebase alloc] initWithUrl: denyUrl];
    [denyRef removeValue];


}
-(void)acceptButtonPressed:(UIButton *)sender {
    acceptedTag = [sender tag];
    HomeScreenViewController *parent = ((HomeScreenViewController *)self.parentViewController);
    [parent setGameKey:gameKeys[[sender tag]]];
    [parent performSegueWithIdentifier: @"acceptInvite" sender: self.parentViewController];


}

@end

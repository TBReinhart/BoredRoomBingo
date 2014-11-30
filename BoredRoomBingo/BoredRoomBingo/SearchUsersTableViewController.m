//
//  SearchUsersTableViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "SearchUsersTableViewController.h"
#import "SearchUsersTableViewCell.h"
#import "config.h"
@interface SearchUsersTableViewController ()
{
    NSMutableArray *userList;
    NSMutableArray *userIDList;
    NSMutableArray *myFriends;
    NSString *gameKey;
    NSString *inviteGameName;
    NSMutableArray *invitedUserList;
    BOOL activeGame;
}
@end

@implementation SearchUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (invitedUserList == nil) {
        invitedUserList = [[NSMutableArray alloc]init];
    } else {
        [invitedUserList removeAllObjects];
    }
}
-(void)setUserList:(NSMutableArray *)list withUserIDs:(NSMutableArray *)userIDs {
    if (userList == nil) {
        userList = [[NSMutableArray alloc]init];
        userIDList = [[NSMutableArray alloc]init];
    }
    userList = list;
    userIDList = userIDs;
}
-(void)setActiveGame:(BOOL)active {
    activeGame = active;
    if (activeGame) {
        // invite everyone
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *myUsername = [prefs stringForKey:@"username"];
        for (int index = 0; index < [userList count]; index++) {
            [self sendInvitation:userIDList[index] withMyUsername:myUsername withGameName:inviteGameName withTheirUsername:userList[index]];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setGameKey:(NSString *)key {
    gameKey = key;
}
-(void)setGameName:(NSString *)gameName {
    inviteGameName = gameName;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [userList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userCell";
    SearchUsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchUsersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.addRemoveButton setTag:indexPath.row];
    [cell.addRemoveButton addTarget:self action:@selector(keepTrackOfInvitedUsers:) forControlEvents:UIControlEventTouchUpInside];
    [cell.friendLabel setText:@""];
    [cell.addRemoveButton setBackgroundImage:[UIImage imageNamed:@"envelope.png"] forState:UIControlStateNormal];
    cell.addRemoveButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    cell.addRemoveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;

    cell.usernameLabel.text = userList[indexPath.row];
    return cell;
}
/**
 Keep track of all users invited
 */
-(void)keepTrackOfInvitedUsers:(UIButton *)sender {
    if (![invitedUserList containsObject:userList[[sender tag]]]) {
        [invitedUserList addObject:userList[[sender tag]]];
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"airplane.png"] forState:UIControlStateNormal];
}
/**
 Check if user has already been invited to the game
 */
-(BOOL)checkIfInvited:(NSString *)thisKey withInvites:(NSDictionary *)invites {
    for (NSDictionary *invite in invites) {
        if ([invites[invite][@"gameKey"] isEqualToString:thisKey]) {
            return YES;
        }
    }
    return NO;
}

/**
 Performs all the invitations at once whenever game start clicked
 */
-(void)sendInvitation:(NSString *)theirID withMyUsername:(NSString *)myUsername withGameName:(NSString *)thisGameName withTheirUsername:(NSString *)theirUsername {
    
    NSString *getUserURL = [NSString stringWithFormat:@"%@users",FIREBASE_URL];
    Firebase *gameRef = [[Firebase alloc] initWithUrl: getUserURL];
    [gameRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
            for (NSDictionary *user in snapshot.value) {
                if( [snapshot.value[user][@"username"] isEqualToString:theirUsername]) {
                    if ([self checkIfInvited:gameKey withInvites:snapshot.value[user][@"invites"]]) {
                        // already invited
                        return;
                    } else {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        NSString *myID = [prefs stringForKey:@"userID"];
                        Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@users/%@/invites",FIREBASE_URL, theirID]];
                        NSDictionary *invitation = @{@"gameKey":gameKey, @"creator":myUsername, @"gameName":thisGameName, @"creatorID":myID};
                        Firebase *newInviteRef = [ref childByAutoId];
                        [newInviteRef setValue:invitation];
                    }
                }
            }
            [self addInviteesToGameKey];
        }
    }];
}
/**
 Add the invitees to the game so that deletions ending the game can delete invitations.
 */
-(void)addInviteesToGameKey {
    NSString *url = [NSString stringWithFormat:@"%@",gameKey];
    Firebase *gameInviteRef = [[Firebase alloc]initWithUrl:url];
    NSDictionary *invitees = @{@"invitees":invitedUserList};
    Firebase *inviteeRef = [gameInviteRef childByAppendingPath:@"invitees"];
    [inviteeRef setValue:invitees];
}
@end

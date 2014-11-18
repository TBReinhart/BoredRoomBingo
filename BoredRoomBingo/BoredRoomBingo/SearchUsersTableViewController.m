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
    NSMutableArray *myFriends;
    NSString *gameKey;
}
@end

@implementation SearchUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)setUserList:(NSMutableArray *)list withFriendsList:(NSMutableArray *)friends {
    if (userList) {
        [userList removeAllObjects];
    } else {
        userList = [[NSMutableArray alloc]init];
    }
    userList = list;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setGameKey:(NSString *)key {
    gameKey = key;
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
    [cell.addRemoveButton setTitle:userList[indexPath.row] forState:UIControlStateNormal];
    [cell.addRemoveButton addTarget:self action:@selector(invitePressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.friendLabel setText:@""];
    cell.usernameLabel.text = userList[indexPath.row];
    return cell;
}
/**
 When you invite a friend, will send invitation
 // TODO: notifications
 */
-(void)invitePressed:(UIButton*)sender {
    // sender.tag is indexpath.row of user looking for
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    NSString *theirUsername = userList[[sender tag]];
    NSString *theirUserID;
    NSString *getUserURL = [NSString stringWithFormat:@"%@users",FIREBASE_URL];
    Firebase *gameRef = [[Firebase alloc] initWithUrl: getUserURL];
    [gameRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
            NSMutableArray *allUsers = [[NSMutableArray alloc]init];
            for (NSDictionary *user in snapshot.value) {
                if( [snapshot.value[user][@"username"] isEqualToString:theirUsername]) {
                    NSLog(@"their name ? %@", [NSString stringWithFormat:@"%@",user]);
                    [self sendInvitation:[NSString stringWithFormat:@"%@",user] withMyUsername:myUsername];
                }
            }
        }
    }];

    [self.tableView reloadData];
}
-(void)sendInvitation:(NSString *)theirID withMyUsername:(NSString *)myUsername {
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@users/%@/invites",FIREBASE_URL, theirID]];
    NSDictionary *invitation = @{@"gameName":gameKey, @"creator":myUsername};
    Firebase *newInviteRef = [ref childByAutoId];
    [newInviteRef setValue:invitation];
}
@end

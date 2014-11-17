//
//  InviteFriendsViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "config.h"
#import "InviteFriendModel.h"
#import "SearchUsersTableViewController.h"
@interface InviteFriendsViewController ()
{
    NSMutableArray *fullUserList;
    NSArray *searchResults;
    NSMutableArray *friendsList;
}
@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchFriendsTextField.delegate = self;
    friendsList = [[NSMutableArray alloc]init];
    [self loadFirebaseInitModel];
    // Do any additional setup after loading the view.
}
/**
 Get All Friends From Firebase.
 */
-(void)loadFirebaseInitModel {
    // TODO: find better way for the below 2 lines
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@users/%@/friends",FIREBASE_URL,myUsername];
    
    Firebase *gameRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    [gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
           friendsList = [[NSMutableArray alloc]init];
            for (NSString *friend in snapshot.value) {
                [friendsList addObject:friend];
            }
            self.model = [[InviteFriendModel alloc]initInviteModel:friendsList];
            SearchUsersTableViewController *tbc = (SearchUsersTableViewController *)self.childViewControllers[0];
            [tbc setUserList:self.model.friends withFriendsList:self.model.friends];
            [tbc.tableView reloadData];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}
/**
 Will load all users from firebase into an array to check for existence to invite to game.
 Should only be called once.
 Perhaps memory heavy for a mature game.
 */
-(void)loadAllUsers {
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@users",FIREBASE_URL];
    Firebase *gameRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    [gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
            fullUserList = [[NSMutableArray alloc]init];
            for (NSString *user in snapshot.value) {
                [fullUserList addObject:user];
            }
            [self searchArray];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}

/**
 Textfield delegate to return if entering new word into list that isn't empty.
 Reload VC after adding.
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // check if word already in list
    if ([self.searchFriendsTextField.text length] > 0 ) {
        if (fullUserList == nil) {
            [self loadAllUsers];
        } else {
            [self searchArray];
        }
        return YES;
    } else {
        [self loadFirebaseInitModel];
    }

    return YES;
}
-(IBAction)textChanges:(id)sender {
    if ([self.searchFriendsTextField.text length] < 1) {
        [self loadFirebaseInitModel];
    }
    if ([self.searchFriendsTextField.text length] > 0 ) {
        if (fullUserList == nil) {
            [self loadAllUsers];
        } else {
            [self searchArray];
        }
    }
}
/**
 Searches array for similar words
 */
-(void)searchArray {
    NSPredicate *userPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    self.searchFriendsTextField.text];
    NSArray *immutable = [fullUserList copy];
    searchResults = [immutable filteredArrayUsingPredicate:userPredicate];
    SearchUsersTableViewController *tbc = (SearchUsersTableViewController *)self.childViewControllers[0];
    [tbc setUserList:[searchResults mutableCopy] withFriendsList:self.model.friends];
    [tbc.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
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

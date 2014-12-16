//
//  InviteFriendsViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/16/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "config.h"
#import "SearchUsersTableViewController.h"
#import "BingoBoardViewController.h"

@interface InviteFriendsViewController () {
    NSMutableArray *fullUserList;
    NSMutableDictionary *usernameToIDs;
    NSArray *searchResults;
    NSMutableArray *friendsList;
    NSMutableArray *userIDs;
}
@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchFriendsTextField.delegate = self;
    [self loadAllUsers];
 //   [self loadFirebaseInitModel];
    // Do any additional setup after loading the view.
}
/**
 Set my notification
 */
-(void)setNotifcations:(NSString *)key withCreator:(NSString *)creator {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:creator forKey:@"channels"];
    [currentInstallation saveInBackground];
}
/**
 Pressed the button to start the game and send out all invitations.
 */
-(IBAction)startGamePressed:(id)sender {
    [self.view endEditing:YES];
    [self didMoveToParentViewController:self];
    SearchUsersTableViewController *tbc = (SearchUsersTableViewController *)self.childViewControllers[0];
    [tbc setActiveGame:YES];
    [self performSegueWithIdentifier:@"activeGameSegue" sender:nil];
}


/**
 Will load all users from firebase into an array to check for existence to invite to game.
 Should only be called once.
 Perhaps memory heavy for a mature game.
 */
-(void)loadAllUsers {
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@users",FIREBASE_URL];
    Firebase *gameRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    [gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
            fullUserList = [[NSMutableArray alloc]init];

            usernameToIDs = [[NSMutableDictionary alloc]init];
            for (NSDictionary *user in snapshot.value) {
                if (![snapshot.value[user][@"username"] isEqualToString:myUsername]) {
                    // this is myself so don't add
                    [fullUserList addObject:snapshot.value[user][@"username"]];
                    [usernameToIDs setValue:user forKey:snapshot.value[user][@"username"]];
                }

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
    if ([self.searchFriendsTextField.text length] > -1 ) { 
        if (fullUserList == nil) {
            [self loadAllUsers];
        } else {
            [self searchArray];
        }
        return YES;
    }
    return YES;
}
/**
 Text changes to search array.
 */
-(IBAction)textChanges:(id)sender {
    if (fullUserList == nil) {
        [self loadAllUsers];
    } else {
        [self searchArray];
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
    [tbc setGameKey:self.gameKey];
    [tbc setGameName:self.gameName];
    if (userIDs == nil) {
        userIDs = [[NSMutableArray alloc]init];
    } else {
        [userIDs removeAllObjects];
    }
    for (NSString *username in searchResults) {
        [userIDs addObject:[usernameToIDs objectForKey:username]];
    }
    [tbc setUserList:[searchResults mutableCopy] withUserIDs:userIDs];
    [tbc.tableView reloadData];
}
/**
 Check for memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 Close text editing
 */
-(IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
/**
 Prepare to move to game and set notifications.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"activeGameSegue"]) {
        NSLog(@"pref for seg in invite");
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *myUsername = [prefs stringForKey:@"username"];
        BingoBoardViewController * bingoBoard = (BingoBoardViewController *)[segue destinationViewController];
        [self setNotifcations:self.gameKey withCreator:myUsername];
        bingoBoard.gameKey = self.gameKey;
    }
}

@end

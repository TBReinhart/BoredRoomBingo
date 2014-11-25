//
//  HomeScreenViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/17/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "BingoBoardViewController.h"
#import <Parse/Parse.h>
@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController
{
    NSString *gameKey;
    NSString *theCreator;
}
- (void)viewDidLoad {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    [self.navigationItem setTitle:myUsername];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 action to perform when the logout button is pressed.
 Should return you to the login screen.
 */
- (IBAction)logoutPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"unwindToLoginSegue" sender:nil];
}


/**
 segue to unwind to login screen from home screen
 */
- (IBAction)unwindToLoginScreen:(UIStoryboardSegue *)segue {
    // should be empty
}
-(void)setGameKey:(NSString *)key withCreator:(NSString *)creator {
    gameKey = key;
    theCreator = creator;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    // segues back to the login screen. Also resets user defaults.
    if ([segue.identifier isEqualToString:@"unwindToLoginSegue"]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:nil forKey:@"email"];
        [prefs setObject:nil forKey:@"userID"]; // for now username is unique id
        [prefs setObject:nil forKey:@"username"]; // for now username is unique id
        [prefs synchronize];
    }
    if ([segue.identifier isEqualToString:@"acceptInvite"]) {
        BingoBoardViewController * bingoBoard = (BingoBoardViewController *)[segue destinationViewController];
        [self setNotifcations:gameKey withCreator:theCreator];
        bingoBoard.gameKey = gameKey;
    }
    
}
/**
 Set Parse Notifications.
 */
-(void)setNotifcations:(NSString *)key withCreator:(NSString *)creator {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSLog(@"the creator in set notifcations %@", theCreator);
    [currentInstallation addUniqueObject:theCreator forKey:@"channels"];
    [currentInstallation saveInBackground];
}


@end

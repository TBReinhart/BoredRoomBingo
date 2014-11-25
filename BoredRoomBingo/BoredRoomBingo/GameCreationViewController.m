//
//  HomeScreen.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/27/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "GameCreationViewController.h"
#import "config.h"
#import "CurrentWordsTableViewController.h"
#import "DetailArchiveWordlistTableViewController.h"
#import "BingoBoardViewController.h"
#import "InviteFriendsViewController.h"
@interface GameCreationViewController ()

@end


@implementation GameCreationViewController
{
    CGFloat keyboardHeight;
    NSString *selectedList;
    NSString *uniqueID;
    BOOL public;
}
/**
 Initialize vc to set current words and delegates.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    public = YES;
    self.addNewWordTextField.delegate = self;
    if (self.currentWords
        == nil) {
        self.currentWords = [[NSMutableArray alloc]init];
    }
    self.backgroundTap.delegate = self;
    [self addToCurrentWords:self.arrayWithWordsToAdd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 Hide Keyboard when background touched and keyboard open
 */
-(IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
/**
 Textfield delegate to return if entering new word into list that isn't empty.
 Reload VC after adding.
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // check if word already in list
    if ([self.currentWords containsObject:self.addNewWordTextField.text]) {
        return YES;
    }
    // check if empty string inserting
    if ([self.addNewWordTextField.text length] < 1) {
        return YES;
    }
    
    [self.currentWords addObject:self.addNewWordTextField.text];
    [self.addNewWordTextField setText:@""];
    CurrentWordsTableViewController *tbc = (CurrentWordsTableViewController *)self.childViewControllers[1];
    [tbc setMyList:self.currentWords];
    [tbc.tableView reloadData];
    return YES;
}
/**
 Adds words to current words from selected list in another vc.
 */
-(void)addToCurrentWords:(NSMutableArray *)wordsToAdd {
    CurrentWordsTableViewController *tbc = [[CurrentWordsTableViewController alloc] init];
    [tbc setMyList:wordsToAdd];
    [tbc.tableView reloadData];
}
/**
 Determines if game is public or private
 
 */
- (IBAction)switchChanged:(UISwitch *)sender {
    if ([self.privatePublicSwitch isOn]) {
        public = YES;
    } else {
        public = NO;
    }
}
/**
 Check if game can be submitted
 */
-(BOOL)validateSubmit {
    if ([self.currentWords count] < 24) {
        UIAlertView *notEnoughWordsAlert = [[UIAlertView alloc]initWithTitle:@"Too Few Words!" message:@"You need at least 24 words to play!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [notEnoughWordsAlert show];
        return NO;
    }
    if ([self.gameNameTextField.text length] < 1) {
        UIAlertView *notEnoughWordsAlert = [[UIAlertView alloc]initWithTitle:@"No Game Name!" message:@"You need a game name to play!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [notEnoughWordsAlert show];
        return NO;
    }
    return YES;
}
/**
 Create game on submit pressed by posting a unique id to firebase 
 */
- (IBAction)submitButtonPressed:(UIButton *)sender {
    if (![self validateSubmit]) {
        return;
    }
    
    NSString *url;
    if (public) {
        url = [NSString stringWithFormat:@"%@game/public",FIREBASE_URL];
    } else {
        url = [NSString stringWithFormat:@"%@game/private",FIREBASE_URL];
    }
    Firebase *ref = [[Firebase alloc] initWithUrl:url];
    Firebase *post1Ref = [ref childByAutoId];
    uniqueID = [NSString stringWithFormat:@"%@",post1Ref];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myID = [prefs stringForKey:@"userID"];
    NSDictionary *gameName = @{@"gameName":self.gameNameTextField.text,
                               @"list":self.currentWords, @"active":@"no", @"winner":@"", @"creator":myID};
    [post1Ref setValue:gameName];
    NSLog(@"post ref %@", post1Ref);
    [self performSegueWithIdentifier:@"inviteFriends" sender:nil];
}
/**
 Overwrites existing list with same name or creates a new list with current words 
 */
- (IBAction)saveListPressed:(UIButton *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myID = [prefs stringForKey:@"userID"];
    NSString *url = [NSString stringWithFormat:@"%@users/%@/wordlists",FIREBASE_URL,myID];
    Firebase *ref = [[Firebase alloc] initWithUrl:url];
    Firebase *listRef = [ref childByAppendingPath: self.listNameTextField.text];
    [listRef setValue: self.currentWords];
}
/**
 Controls max length textfield text to 19 characters.
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 19) ? NO : YES;
}
/**
 Delegate method of when text field starts editing 
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}
/** 
 Delegate when text ends editing
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
/**
 Called when the UIKeyboardDidShowNotification is sent.
 */
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardHeight = kbSize.height;
}
/**
 Moves view up to make room for keyboard.
 */
-(void)animateTextField:(UITextField*)textField up:(BOOL)up {
    const int movementDistance = -130; // tweak as needed
    
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
/**
 Recognizes a background tap gesture to remove keyboard from screen.
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.view]) {
        [self backgroundTap:nil];
        return NO;
    }
    return YES;
}
/**
 Sets selected list
 */
-(void)setList:(NSString *)list {
    selectedList = list;
}
/**
 Getter for selectedList
 */
-(NSString *)getList {
    return selectedList;
}
/** 
 Passes data from one view controller to another.
 Sets selected list to child view controller or goes to board
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectListSegue"]) {
        DetailArchiveWordlistTableViewController * childViewController = (DetailArchiveWordlistTableViewController *) [segue destinationViewController];
        ArchivedWordListsTableViewController *tbc = (ArchivedWordListsTableViewController *)self.childViewControllers[0];
        NSLog(@"tbc's detail %@", tbc.listToPass);
        [childViewController setSelectedList:tbc.listToPass];
    }
    if ([segue.identifier isEqualToString:@"inviteFriends"]) {
        InviteFriendsViewController *friendVC = (InviteFriendsViewController *)[segue destinationViewController];
        friendVC.gameKey = uniqueID;
        friendVC.gameName = self.gameNameTextField.text;
    }
}

/**
 Unwind segue necessary to move back to this view controller without making a new VC
 */
- (IBAction)unwindToGameCreationViewController:(UIStoryboardSegue *)segue {
    for (NSString *word in self.arrayWithWordsToAdd) {
        if (![self.currentWords containsObject:word]) {
            [self.currentWords addObject:word];
        }
    }
    CurrentWordsTableViewController *tbc = (CurrentWordsTableViewController *)self.childViewControllers[1];
    [tbc setMyList:self.currentWords];
    [tbc.tableView reloadData];
    //nothing goes here
}
@end

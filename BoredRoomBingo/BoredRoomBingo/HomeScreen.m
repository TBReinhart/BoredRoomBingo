//
//  HomeScreen.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/27/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "HomeScreen.h"
#import "config.h"
#import "CurrentWordsTableViewController.h"
@interface HomeScreen ()

@end


@implementation HomeScreen
{
    CGFloat keyboardHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.addNewWordTextField.delegate = self;
    self.currentWords = [[NSMutableArray alloc]init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
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
- (IBAction)submitButtonPressed:(UIButton *)sender {

}
- (IBAction)saveListPressed:(UIButton *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    NSString *url = [NSString stringWithFormat:@"%@users/%@/wordlists",FIREBASE_URL,myUsername];
    Firebase *ref = [[Firebase alloc] initWithUrl:url];
    Firebase *listRef = [ref childByAppendingPath: self.listNameTextField.text];
    [listRef setValue: self.currentWords];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 19) ? NO : YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"height is %f", kbSize.height);
    keyboardHeight = kbSize.height;
}
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



@end

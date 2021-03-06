//
//  ChatViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/24/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
// 

#import "ChatViewController.h"
#import "BingoBoardViewController.h"
@interface ChatViewController ()
@property (nonatomic) BOOL newMessagesOnTop;
@end

@implementation ChatViewController

@synthesize messageTextField;
@synthesize chatTableView;
@synthesize newMessagesOnTop;

/**
 Load the view controller with all chat messages and users
 Once again, code adapted from https://github.com/firebase/firechat-ios
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize array that will store chat messages.
    self.chat = [[NSMutableArray alloc] init];
    // Initialize the root of our Firebase namespace.
    NSString *gameChatUrl = [NSString stringWithFormat:@"%@/chat",self.url];
    self.firebase = [[Firebase alloc] initWithUrl:gameChatUrl];
    self.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
    newMessagesOnTop = YES;
    __block BOOL initialAdds = YES;
    
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        if (newMessagesOnTop) {
            [self.chat insertObject:snapshot.value atIndex:0]; // change here to be at bottom count - 1
        } else {
            [self.chat addObject:snapshot.value];
        }
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            [self.chatTableView reloadData];
        }
    }];
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.chatTableView reloadData];
        initialAdds = NO;
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 When enter pressed message should send and clear 
 */
- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    if ([aTextField.text length] > 0) {
        [[self.firebase childByAutoId] setValue:@{@"name" : self.username, @"text": aTextField.text}];
    }
    [aTextField setText:@""];
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}
/**
 Return number of cell rows equaling number of messages
 */
- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [self.chat count];
}

/**
 Changes height of cell text depending on how big the message is.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* chatMessage = [self.chat objectAtIndex:indexPath.row];
    
    NSString *text = chatMessage[@"text"];
    const CGFloat TEXT_LABEL_WIDTH = 260;
    CGSize constraint = CGSizeMake(TEXT_LABEL_WIDTH, 20000);
    
    // typical textLabel.font = font-family: "Helvetica"; font-weight: bold; font-style: normal; font-size: 18px
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping]; // requires iOS 6+
    const CGFloat CELL_CONTENT_MARGIN = 22;
    CGFloat height = MAX(CELL_CONTENT_MARGIN + size.height, 44);
    
    return height;
}

/**
 Sets each cell with message text and username text
 */
- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSDictionary* chatMessage = [self.chat objectAtIndex:index.row];
    
    cell.textLabel.text = chatMessage[@"text"];
    cell.detailTextLabel.text = chatMessage[@"name"];
    
    return cell;
}
/**
 Set keyboard show/hide notifications.
 */
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

/**
 Unsubscribe from keyboard show/hide notifications.
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 Setup keyboard handlers to slide the view containing the table view and
 text field upwards when the keyboard shows, and downwards when it hides.
*/
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:YES];
}
/**
 hide keyboard and move down view
 */
- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:NO];
}

/**
 move view up when keyboard opens or down to hide
 */
- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    
    // Get the correct keyboard size to we slide the right amount.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
    
    [UIView commitAnimations];
}

/**
 This method will be called when the user touches on the tableView, at
 which point we will hide the keyboard (if open). This method is called
 because UITouchTableView.m calls nextResponder in its touch handler.
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if ([messageTextField isFirstResponder]) {
        [messageTextField resignFirstResponder];
    }
}

@end

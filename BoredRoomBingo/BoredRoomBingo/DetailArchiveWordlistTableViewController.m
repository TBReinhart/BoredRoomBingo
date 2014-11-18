//
//  DetailArchiveWordlistTableViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/3/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "DetailArchiveWordlistTableViewController.h"
#import "SelectWordTableViewCell.h"
#import "CurrentWordsTableViewController.h"
#import "GameCreationViewController.h"
#import "config.h"
#import <Firebase/Firebase.h>
@interface DetailArchiveWordlistTableViewController ()
{
    NSString *detailList;
    NSMutableArray *words;
    NSMutableArray *selectedWords;
}
@end

@implementation DetailArchiveWordlistTableViewController

/**
 On Load set the nav title, fetch data, and set nav button
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = detailList;
    words = [[NSMutableArray alloc]init];
    [self getData];
    selectedWords = [[NSMutableArray alloc]init];
    self.doneBarButton = [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem= self.doneBarButton;
}
/**
 When You press OK/done to finish selecting current words. 
 needs to segue back to a VC with a current word list that includes all previous and new words
 */
-(void)donePressed:(id)sender {
    [self performSegueWithIdentifier:@"unwindToGameCreationViewController" sender:self];
}
/**
 Sets which VC will be used for use when fetching data and setting nav bar.
 */
-(void)setSelectedList:(NSString *)selectedList {
    detailList = selectedList;
}
/**
 Default
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 Encode String to send to proper hyperlink. Can Refactor
 */
- (NSString*)encodeString:(NSString*)string
{
    NSString *encodedString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedString;
}
/**
 Only one section of same things in table set.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
/**
 Sets number of rows 1:1 with number of words in list
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [words count];
}
/**
 Uses Firebase to fetch data. will continually reload data to update real time.
 */
-(void)getData {
    // Get a reference to our posts
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myID = [prefs stringForKey:@"userID"];
    NSString *encodedList = [self encodeString:detailList];

    NSString *wordlistUrl = [NSString stringWithFormat:@"%@users/%@/wordlists/%@",FIREBASE_URL,myID,encodedList];
    Firebase *postsRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    // Attach a block to read the data at our posts reference
    [postsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        BOOL b = YES;
        if ([words count] > 0) {
            [words removeAllObjects];
        }
        if (snapshot.value != [NSNull null]) {
            for (NSString *word in snapshot.value) {
                [words addObject:word];
                [selectedWords addObject:[NSNumber numberWithBool:b]];
            }
        }
        [self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];
}
/**
 Determines what will be at each cell.
 Sets row with a remove button and word from list
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"selectWord";
    SelectWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SelectWordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectButton.tag = indexPath.row;
    [cell.selectButton setTitle:@"remove" forState:UIControlStateNormal];
    cell.wordLabel.text = words[indexPath.row];
    [cell.selectButton addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
/**
 When you select or deselect a word to add to your current list
 */
-(void)selectPressed:(UIButton*)sender {
    
    BOOL n = NO;
    BOOL y = YES;
    if ([[selectedWords objectAtIndex:sender.tag] boolValue]) { // if object is currently selected, push unselects
        [sender setTitle:@"add" forState:UIControlStateNormal];
        [selectedWords setObject:[NSNumber numberWithBool:n] atIndexedSubscript:sender.tag];
    } else { // adds back
        [sender setTitle:@"remove" forState:UIControlStateNormal];
        [selectedWords setObject:[NSNumber numberWithBool:y] atIndexedSubscript:sender.tag];
    }
    //[self.tableView reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"unwindToGameCreationViewController"]) {
        NSMutableArray *tempToSend = [[NSMutableArray alloc]init];
        for (int i = 0; i < [words count]; i++) {
            if ([[selectedWords objectAtIndex:i] boolValue]) {
                [tempToSend addObject:words[i]];
            }
        }
        GameCreationViewController *controller = (GameCreationViewController *)segue.destinationViewController;
        controller.arrayWithWordsToAdd = tempToSend;
       // [controller addToCurrentWords:tempToSend];
    }
}

@end

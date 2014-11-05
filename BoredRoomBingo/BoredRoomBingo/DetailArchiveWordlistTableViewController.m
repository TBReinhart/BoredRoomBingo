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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = detailList;
    words = [[NSMutableArray alloc]init];
    [self getData];
    selectedWords = [[NSMutableArray alloc]init];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem= doneItem;
}
-(void)donePressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setSelectedList:(NSString *)selectedList {
    detailList = selectedList;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*)encodeString:(NSString*)string
{
    NSString *encodedString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return encodedString;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [words count];
}
-(void)getData {
    // Get a reference to our posts
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myUsername = [prefs stringForKey:@"username"];
    NSString *encodedList = [self encodeString:detailList];

    NSString *wordlistUrl = [NSString stringWithFormat:@"%@users/%@/wordlists/%@",FIREBASE_URL,myUsername,encodedList];
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
    
}


@end

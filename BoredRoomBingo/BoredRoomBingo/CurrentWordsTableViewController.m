//
//  CurrentWordsTableViewController.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/28/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "CurrentWordsTableViewController.h"
#import "CurrentWordsTableViewCell.h"
@interface CurrentWordsTableViewController ()
{
    NSMutableArray *myList;
}
@end

@implementation CurrentWordsTableViewController

/**
 On load do nothing. later need to make sure words stay in list even when going to select from previous list
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 Set list. if null alloc list adnd set, else add unique words to list.
 */
-(void)setMyList:(NSMutableArray *)list {
    if (myList) {
        for (NSString *word in list) {
            if (![myList containsObject:word]) {
                [myList addObject:word];
            }
        }
    } else {
        myList = [[NSMutableArray alloc]init];
        myList = list;
    }
   //[self.tableView reloadData];
}
/**
 Only 1 section per cell
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
/** 
 1:1 word from list for each cell
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [myList count];
}
/**
 Sets the cell at each row, will display with newest at top of table
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"myWordCell";
    CurrentWordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CurrentWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.xButton.tag = indexPath.row;
    [cell.aCurrentWordLabel setText:[myList objectAtIndex:myList.count - indexPath.row - 1]];
    cell.aCurrentWordLabel.minimumScaleFactor = 8./cell.aCurrentWordLabel.font.pointSize;
    cell.aCurrentWordLabel.numberOfLines = 2;
    cell.aCurrentWordLabel.adjustsFontSizeToFitWidth = YES;

    [cell.xButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
/**
 Deletes From Array
 */
-(void)deleteButtonPressed:(UIButton*)sender {
    [myList removeObjectAtIndex:myList.count - sender.tag - 1];
    [self.tableView reloadData];
}

@end

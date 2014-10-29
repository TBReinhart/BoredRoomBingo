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


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load %@", myList);
    myList = [[NSMutableArray alloc]init];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // check here, if it is one of the cells, that needs to be resized
//    // to the size of the contained UITextView
//    if (  )
//        return [self textViewHeightForRowAtIndexPath:indexPath];
//    else
//        // return your normal height here:
//        return 100.0;
//}


-(void)setMyList:(NSMutableArray *)list {
    myList = list;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [myList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"myWordCell";
    CurrentWordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CurrentWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.wordTextView setText:myList[indexPath.row]];
    
    //[textViews setObject:cell.textView forKey:indexPath];
    //[cell.textView setDelegate: self]; // Needed for step 3
    
    return cell;
}


@end

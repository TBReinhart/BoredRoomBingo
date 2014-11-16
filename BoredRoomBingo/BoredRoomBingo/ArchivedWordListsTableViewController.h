//
//  ArchivedWordListsTableViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/3/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 Displays all names of existing user word lists.
 */
@interface ArchivedWordListsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *listToPass; ///< String containing name of string to pass for load from firebase

@end

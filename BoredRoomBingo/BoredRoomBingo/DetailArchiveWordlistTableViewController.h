//
//  DetailArchiveWordlistTableViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/3/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 The table view controller for selecting a specific existing list. 
 */
@interface DetailArchiveWordlistTableViewController : UITableViewController
-(void)setSelectedList:(NSString *)selectedList;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButton; ///< select done to add to current words.
@end

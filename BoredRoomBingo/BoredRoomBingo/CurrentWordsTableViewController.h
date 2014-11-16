//
//  CurrentWordsTableViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/28/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 Table View Controller displaying current words.
 */
@interface CurrentWordsTableViewController : UITableViewController
-(void)setMyList:(NSMutableArray *)list; ///< sets which list to set in current words
@end

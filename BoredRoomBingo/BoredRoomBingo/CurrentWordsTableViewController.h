//
//  CurrentWordsTableViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/28/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentWordsTableViewController : UITableViewController
-(void)setMyList:(NSMutableArray *)list;
@property (nonatomic,strong) NSMutableArray *listOfWords;
@end

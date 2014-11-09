//
//  SelectWordTableViewCell.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/4/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectWordTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *wordLabel; ///< Label for word from list
@property (strong, nonatomic) IBOutlet UIButton *selectButton; ///< Button for selecting/deselecting for adding to current words

@end

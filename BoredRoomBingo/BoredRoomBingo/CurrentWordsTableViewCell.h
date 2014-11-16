//
//  CurrentWordsTableViewCell.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/28/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 Cell for current words. Can remove word from this list.
 */
@interface CurrentWordsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *aCurrentWordLabel; ///< Label containing word to be in pool of words for game.
@property (strong, nonatomic) IBOutlet UIButton *xButton; ///< Button removing a current word from list


@end

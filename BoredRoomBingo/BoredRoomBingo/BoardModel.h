//
//  BoardModel.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/14/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"


static const int ROWS = 5 ;
static const int COLUMNS = 5 ;
/**
 Model for the bingo board game.
 */
@interface BoardModel : NSObject
@property (nonatomic,strong) NSMutableArray *boolBoard; ///< Grid of booleans that determine which space occupied.
-(NSMutableArray *)getRandomList;
-(instancetype)initBoardModel:(NSString *)gameKey withFullList:(NSMutableArray *)fullList;
@property (nonatomic, strong) NSMutableArray *randomList;
@end

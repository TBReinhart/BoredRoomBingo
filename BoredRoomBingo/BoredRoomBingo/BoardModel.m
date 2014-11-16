//
//  BoardModel.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/14/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "BoardModel.h"

@implementation BoardModel


// 5x5 boolean grid
// 5x5 string grid
{
    NSMutableArray *boolGrid;

}
/**
 Check what words on board have been used.
 */
-(void)checkUsedWords {
    for (int rows = 0; rows < ROWS; rows++) {
        for (int columns = 0; columns < COLUMNS; columns++) {
            
        }
    }
}
/**
 Initialize grids of words and booleans.
 */
-(void)setUpGrids {
    for (int i = 0; i < ROWS * COLUMNS; i++) {
        boolGrid[i] = @NO;
    }
    boolGrid[(ROWS*COLUMNS)/2] = @YES;
}
/**
 randomize list of words to use from pool of all words
 once select word to put on board, remove from total words and decrease count to find new random.
 */
-(void)randomizeList:(NSMutableArray *)fullList {
    NSUInteger randomIndex;
    self.randomList = [[NSMutableArray alloc]initWithCapacity:ROWS*COLUMNS];
    for (int i = 0; i < (ROWS*COLUMNS) - 1; i++) {
        randomIndex = arc4random() % [fullList count];
        [self.randomList addObject:[fullList objectAtIndex:randomIndex]];
        [fullList removeObjectAtIndex:randomIndex];
    }
  //  [self.randomList insertObject:@"free" atIndex:12 ];
    // TODO select a different way to add free to list of words 
}
/**
 Get pool of words from firebase 
 */
-(instancetype)initBoardModel:(NSString *)gameKey withFullList:(NSMutableArray *)fullList {
    boolGrid = [[NSMutableArray alloc]initWithCapacity:ROWS*COLUMNS];
    [self randomizeList:fullList];

    return self;
}

-(NSMutableArray *)getRandomList {
    return self.randomList;
}
@end

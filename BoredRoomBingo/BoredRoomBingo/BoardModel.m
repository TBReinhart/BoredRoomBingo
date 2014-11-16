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
    NSMutableArray *randomList;

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
    randomList = [[NSMutableArray alloc]initWithCapacity:ROWS*COLUMNS];
    for (int i = 0; i < (ROWS*COLUMNS) - 1; i++) {
        randomIndex = arc4random() % [fullList count];
        [randomList addObject:[fullList objectAtIndex:randomIndex]];
        [fullList removeObjectAtIndex:randomIndex];
    }
    [randomList insertObject:@"free" atIndex:(ROWS*COLUMNS)/2];
}
/**
 Get pool of words from firebase 
 */
-(instancetype)initBoardModel:(NSString *)gameKey {
    boolGrid = [[NSMutableArray alloc]initWithCapacity:ROWS*COLUMNS];
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@",gameKey];
    NSLog(@"game key is %@", gameKey);
    Firebase *gameRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    [gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            // When creating game # words checked
            NSMutableArray *fullList = [[NSMutableArray alloc]init];
            for (NSString *word in snapshot.value[@"list"]) {
                [fullList addObject:word];
            }
            [self randomizeList:fullList];
            NSLog(@"random list now %@", randomList);
            [self setUpGrids];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);
    }];

    return self;
}
-(void)loadFirebase {
    
}
-(NSMutableArray *)getRandomList {
    return randomList;
}
@end

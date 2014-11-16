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
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLUMNS; j++) {
            boolGrid[i][j] = @NO;
        }
    }
    boolGrid[ROWS/2][COLUMNS/2] = @YES;
}

/**
 randomize list of words to use from pool of all words
 once select word to put on board, remove from total words and decrease count to find new random.
 */
-(void)randomizeList:(NSMutableArray *)fullList {
    NSUInteger randomIndex;
    self.randomList = [[NSMutableArray alloc]initWithCapacity:ROWS*COLUMNS];
    for (int i = 0; i < (ROWS*COLUMNS - 1); i++) {
        randomIndex = arc4random() % [fullList count];
        [self.randomList addObject:[fullList objectAtIndex:randomIndex]];
        [fullList removeObjectAtIndex:randomIndex];
    }
    [self setUpGrids];
    [self.randomList insertObject:@"BORED ROOM" atIndex:12];
    // TODO select a different way to add free to list of words
}
/**
 Get pool of words from firebase 
 */
-(instancetype)initBoardModel:(NSString *)gameKey withFullList:(NSMutableArray *)fullList {
    boolGrid = [[NSMutableArray alloc]initWithCapacity:ROWS];
    for (int i = 0; i < COLUMNS; i++) {
        [boolGrid setObject:[[NSMutableArray alloc]initWithCapacity:COLUMNS] atIndexedSubscript:i];
    }
    [self randomizeList:fullList];
    return self;
}

-(NSMutableArray *)getRandomList {
    return self.randomList;
}

-(void)wordToggledatLocation:(NSInteger)row withColumn:(NSInteger)column {
    NSLog(@"%@" , boolGrid[row]);
    [[boolGrid objectAtIndex:row] replaceObjectAtIndex:column withObject:@YES];
    
}

-(NSMutableArray *)getBoolGrid {
    return boolGrid;
}

/**
 Checks for winning row on board.
 */
-(BOOL)checkForWinRow {
    BOOL rowValid = YES;
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLUMNS; j++) {
            if ([boolGrid[i][j] isEqual:@NO]) {
                rowValid = NO;
                break;
            }
        }
        if (rowValid) {
            return YES;
        } else {
            rowValid = YES;
        }
    }
    return NO;
}


/**
 Checks for winning column on board.
 */
-(BOOL)checkForWinColumn {
    BOOL columnValid = YES;
    for (int j = 0; j < COLUMNS; j++) {
        for (int i = 0; i < ROWS; i++) {
            if ([boolGrid[i][j] isEqual:@NO]) {
                columnValid = NO;
                break;
            }
        }
        if (columnValid) {
            return YES;
        } else {
            columnValid = YES;
        }
    }
    return NO;
}

/**
 Checks for winning diagonal on board.
 */
-(BOOL)checkForWinDiagonal {
    BOOL d1Valid = YES;
    BOOL d2Valid = YES;
    for (int j = 0; j < COLUMNS; j++) {
        if ([boolGrid[j][j] isEqual: @NO]) {
            d1Valid = NO;
        }
        if ([boolGrid[j][COLUMNS - j - 1] isEqual: @NO]) {
            d2Valid = NO;
        }
    }
    return d1Valid || d2Valid;
}

/**
 Checks to see if there is a win condition on the board.
 */
-(BOOL)checkForWin {
    return [self checkForWinColumn] || [self checkForWinDiagonal] || [self checkForWinRow];
}

@end
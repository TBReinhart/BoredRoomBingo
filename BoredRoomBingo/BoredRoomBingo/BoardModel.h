//
//  BoardModel.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/14/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardModel : NSObject
@property (nonatomic,strong) NSMutableArray *boolBoard;
-(void)initBoard:(NSMutableArray *)wordList;
@end

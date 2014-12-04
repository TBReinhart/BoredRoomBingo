//
//  UITouchTableView.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/24/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import "UITouchTableView.h"

@implementation UITouchTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/**
 Sets touches allowed on table
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.nextResponder touchesBegan:touches withEvent:event];
}

@end

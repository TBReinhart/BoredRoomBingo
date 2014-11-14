//
//  BingoBoardViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BingoBoardViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *boardButton;
@property (nonatomic,strong) NSMutableArray *boardWords;
@property (nonatomic,strong) NSString *gameKey;


@end

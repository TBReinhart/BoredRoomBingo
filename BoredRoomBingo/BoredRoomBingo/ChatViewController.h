//
//  ChatViewController.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/24/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong) Firebase* firebase;
@property (nonatomic, strong) NSString *url;

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@end

//
//  HomeScreen.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/27/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreen : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addNewWordTextField;
@property (strong, nonatomic) IBOutlet UITextField *listNameTextField;
@property (strong, nonatomic) IBOutlet UISwitch *privatePublicSwitch;
@property (nonatomic,strong) NSMutableArray *currentWords;

@end

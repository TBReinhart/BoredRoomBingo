//
//  InvitationTableViewCell.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 11/19/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InvitationsTableViewCellDelegate <NSObject>
- (void)acceptActionForItemText:(NSString *)gameName;
- (void)denyActionForItemText:(NSString *)gameName;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end
@interface InvitationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *creatorLabel;
// swipeable
@property (nonatomic, weak) IBOutlet UIButton *acceptButton;
@property (nonatomic, weak) IBOutlet UIButton *denyButton;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (nonatomic, weak) id <InvitationsTableViewCellDelegate> delegate;
- (void)openCell;

@end

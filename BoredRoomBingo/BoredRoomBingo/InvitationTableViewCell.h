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
/**
 A Swipeable invitation cell for accepting and denying invitations.
 */
@interface InvitationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *gameNameLabel; ///< Name of Label for Invite
@property (strong, nonatomic) IBOutlet UILabel *creatorLabel; ///< Name of Creator For Invite
// swipeable
@property (nonatomic, weak) IBOutlet UIButton *acceptButton; ///< Accept invitation button
@property (nonatomic, weak) IBOutlet UIButton *denyButton; ///< Deny invitation button
@property (nonatomic, weak) IBOutlet UIView *myContentView; ///< content in cell view
@property (nonatomic, weak) id <InvitationsTableViewCellDelegate> delegate; ///< Invitation Cell Delegate
- (void)openCell;

@end

//
//  ErrorMessage.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/21/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 The view controller that handles errors from Firebase.
 */
@interface ErrorMessage : UIViewController
/**
    Determines error message to display
    @param error is the error code from Firebase
*/
-(void)errorMessages:(NSError*)error;
@end

//
//  LoginError.h
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 12/9/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Abstract class defined to encapsulate erros.
 */
@interface LoginError : NSError

@property (strong, nonatomic) NSString *errorTitle; ///> The title of this particular error. 
@property (strong, nonatomic) NSString *errorData; ///> The data associated with this error. AKA the error message.

/**
 Returns the error data associated with this error
 */
-(NSString*)getErrorData;


/**
 returns the error title associated with this error
 */
-(NSString*)getErrorTitle;
@end

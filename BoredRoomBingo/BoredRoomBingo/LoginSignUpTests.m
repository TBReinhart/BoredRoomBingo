//
//  LoginSignUpTests.m
//  BoredRoomBingo
//
//  Created by Tom Reinhart on 10/26/14.
//  Copyright (c) 2014 Tom Reinhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LoginSignUp.h"
#import "config.h"
#import "BoardModel.h"
#import <Firebase/Firebase.h>
@interface LoginSignUpTests : XCTestCase

@end

@implementation LoginSignUpTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    NSLog(@"ref is %@", ref);
    [ref authUser:@"ian@brb.com" password:@"tester"
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
    if (error) {
        NSLog(@"failed logging in with error: %@", error);
        XCTFail(@"Failed logging in!");
        // There was an error logging in to this account
    } else {
        NSLog(@"logged in");
        XCTAssert(YES, @"Logged in :) ");
        
        // We are now logged in
    }
    [expectation fulfill];

    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];

}
- (void)testLoginBadPassword {
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    NSLog(@"ref is %@", ref);
    [ref authUser:@"ian@brb.com" password:@"badPassword"
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error.code == FAuthenticationErrorInvalidPassword) {
        XCTAssert(YES, @"Bad Login");
        // There was an error logging in to this account
    } else {
        XCTFail(@"password wasn't incorrect!");
        // We are now logged i
    }
    [expectation fulfill];
    
}];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
}


NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

-(void)testSignUp {
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    NSString *fakeEmail = [NSString stringWithFormat:@"%@@brb.com",[self randomStringWithLength:10]];
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref authUser:fakeEmail password:@"tester"
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    NSLog(@"in log in test");
    if (error.code == FAuthenticationErrorUserDoesNotExist) {

        [self makeAcct:fakeEmail];

        // There was an error logging in to this account
    } else {
        XCTFail(@"failed other than no username when logging in");
        // We are now logged i
    }
    [expectation fulfill];
    
}];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}
-(void)makeAcct:(NSString *)fakeEmail {
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [ref createUser:fakeEmail password:@"tester"
withCompletionBlock:^(NSError *error) {
    NSLog(@"in create");
    if (error) {
        XCTFail(@"Failed at creation");
        // There was an error creating the account
    } else {
        NSLog(@"NEW ACCOUNT WITH EMAIL %@", fakeEmail);
        XCTAssert(YES, @"success");
        // We created a new user account
    }
    
}];
}
-(void)testFacebookLoginSuccess {
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE_URL];
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      
                                      if (error) {
                                          NSLog(@"Facebook login failed. Error: %@", error);
                                      } else if (state == FBSessionStateOpen) {
                                          NSString *accessToken = session.accessTokenData.accessToken;
                                          [ref authWithOAuthProvider:@"facebook" token:accessToken
                                                 withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                     
                                                     if (error) {
                                                         XCTFail(@"login failed :(");
                                                     } else {
                                                         NSLog(@"logged in");
                                                         XCTAssert(YES, @"logged in");
                                                     }
                                                 }];
                                      }
                                  }];
}
-(void)testRepeatWords {
    
}
-(void)testRowWin {
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (int i = 0; i < ROWS * COLUMNS; i++) {
        [list addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    BoardModel *model = [[BoardModel alloc]initBoardModel:@"test" withFullList:list];
    for (int col = 0; col < COLUMNS; col++) {
        [model wordToggledatLocation:0 withColumn:col];
    }
    if ([model checkForWin]) {
        XCTAssert(YES, @"hor win");
    } else {
        XCTFail(@"you didn't win");
    }
}
-(void)testRowNotWin {
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (int i = 0; i < ROWS * COLUMNS; i++) {
        [list addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    BoardModel *model = [[BoardModel alloc]initBoardModel:@"test" withFullList:list];
    for (int col = 0; col < COLUMNS - 1; col++) {
        [model wordToggledatLocation:0 withColumn:col];
    }
    if ([model checkForWin]) {
        XCTFail(@"should not have won");
    } else {
        XCTAssertTrue(YES,@"you didn't win");
    }
}
-(void)testDiagonalWin {
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (int i = 0; i < ROWS * COLUMNS; i++) {
        [list addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    BoardModel *model = [[BoardModel alloc]initBoardModel:@"test" withFullList:list];

    for (int i = 0; i < ROWS; i++) {
        [model wordToggledatLocation:i withColumn:i];
    }
    XCTAssertTrue([model checkForWin], @"Diagonal Win");
}
-(void)testColumnWin {
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (int i = 0; i < ROWS * COLUMNS; i++) {
        [list addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    BoardModel *model = [[BoardModel alloc]initBoardModel:@"test" withFullList:list];
    for (int row = 0; row < ROWS; row++) {
        [model wordToggledatLocation:row withColumn:0];
    }
    if ([model checkForWin]) {
        XCTAssert(YES, @"vert win");
    } else {
        XCTFail(@"you didn't win");
    }
}
-(void)testColumnNotWin {
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (int i = 0; i < ROWS * COLUMNS; i++) {
        [list addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    BoardModel *model = [[BoardModel alloc]initBoardModel:@"test" withFullList:list];
    for (int row = 0; row < ROWS - 1; row++) {
        [model wordToggledatLocation:row withColumn:0];
    }
    if ([model checkForWin]) {
        XCTFail(@"should not win");
    } else {
        XCTAssertTrue(YES, @"nonwinnning situation");
    }
}
- (void)testGameCreation {
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (int i = 0; i < 25; i++) {
        [list addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@game/public",FIREBASE_URL];
    Firebase *ref = [[Firebase alloc] initWithUrl:url];
    Firebase *post1Ref = [ref childByAutoId];
    NSString *uniqueID = [NSString stringWithFormat:@"%@",post1Ref];
    NSDictionary *gameName = @{@"gameName":@"testGame",
                               @"list":list};
    [post1Ref setValue:gameName];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    NSString *wordlistUrl = [NSString stringWithFormat:@"%@",uniqueID];
    Firebase *gameRef = [[Firebase alloc] initWithUrl: wordlistUrl];
    [gameRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value != [NSNull null]) {
            NSMutableArray *fullList = [[NSMutableArray alloc]init];
            for (NSString *word in snapshot.value[@"list"]) {
                [fullList addObject:word];
            }
            for (int i = 0; i < [fullList count]; i++) {
                if (![list containsObject:[fullList objectAtIndex:i]] ) {
                    XCTFail(@"should be in list");
                }
            }
        }
        [expectation fulfill];

    } withCancelBlock:^(NSError *error) {
        NSLog(@"Cancel block %@", error.description);

    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

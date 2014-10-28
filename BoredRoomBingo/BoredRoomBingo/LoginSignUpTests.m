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
        NSLog(@"error: %@",error);
        XCTAssert(YES, @"Wrong Password");
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
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//
//  RegexTests.m
//  base
//
//  Created by Demi on 14/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Validation.h"

@interface RegexTests : XCTestCase

@end

@implementation RegexTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTAssertTrue([@"taylor@tetx.com" isValidEmail]);
    XCTAssertFalse([@"taylorfjdalf_7&@tetx.com" isValidEmail]);
    XCTAssertTrue([@"taylor223_+@tetx.cn.abc.com" isValidEmail]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

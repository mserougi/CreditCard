//
//  CreditCardTests.m
//  CreditCardTests
//
//  Created by Mohammed on 7/8/17.
//

#import <XCTest/XCTest.h>
#import "CreditCardControl.h"

@interface CreditCardTests : XCTestCase

@property CreditCardControl *testControl;

@end

@implementation CreditCardTests

- (void) setUp
{
    [super setUp];
    
    _testControl = [[CreditCardControl alloc] init];
}

- (void) tearDown
{
    _testControl = nil;
    
    [super tearDown];
}

- (void) testLuhnCreditCardNumberValidation
{
    XCTAssert([_testControl validateCardNumberOffline:@"4712456082585550"] == YES, @"FAIL: Luhn working!");
    XCTAssert([_testControl validateCardNumberOffline:@"1234123412341234"] == NO, @"FAIL: Luhn not working!");
}

- (void) testCreditCardNumberGeneration
{
    XCTAssert([_testControl generateValidCardNumber] != nil, @"FAIL: Unable to generate a valid credit card number!");
}

@end

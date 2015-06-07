//
//  Card.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Transaction.h"

static NSString *SAVED_CARDS = @"SAVED_CARDS";

@protocol Card <NSObject, NSCoding>

@required
- (instancetype) initWithEverything:(NSString*)cardNumber expirMonth:(NSString*)expirMonth
                          expirYear:(NSString*)expirYear cvvCode:(NSString*)cvvCode;

- (id) initWithCoder:(NSCoder *)aDecoder;
- (void) encodeWithCoder:(NSCoder *)aCoder;

- (NSURLRequest*) generateBalanceURLRequest;

- (BOOL) isValidCard:(NSData*)webPageData;
- (NSString*) startingBalance:(NSData*)webPageData;
- (NSString*) currentBalance:(NSData*)webPageData;
- (NSMutableArray*) transactions:(NSData*)webPageData;
- (NSString*) hiddenCardNumberFormat;

@property (strong, nonatomic, readwrite) NSString *cardNumber;
@property (strong, nonatomic, readwrite) NSString *expirMonth;
@property (strong, nonatomic, readwrite) NSString *expirYear;
@property (strong, nonatomic, readwrite) NSString *cvvCode;

@property (strong, nonatomic, readwrite) NSString *startingBalance;
@property (strong, nonatomic, readwrite) NSString *currentBalance;

@property (strong, nonatomic, readwrite) NSData *tempDataStore;

@end
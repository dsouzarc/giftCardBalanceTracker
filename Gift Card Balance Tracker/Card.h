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

//Tag for saving cards
static NSString *SAVED_CARDS = @"SAVED_CARDS";

@protocol Card <NSObject, NSCoding>

//Required before creation (all should have this)
@property (strong, nonatomic, readwrite) NSString *cardNumber;
@property (strong, nonatomic, readwrite) NSString *expirMonth;
@property (strong, nonatomic, readwrite) NSString *expirYear;
@property (strong, nonatomic, readwrite) NSString *cvvCode;

//Optional after instantiation
@property (strong, nonatomic, readwrite) NSData *tempDataStore;
@property (strong, nonatomic, readwrite) NSString *startingBalance;
@property (strong, nonatomic, readwrite) NSString *currentBalance;

- (instancetype) initWithEverything:(NSString*)cardNumber expirMonth:(NSString*)expirMonth
                          expirYear:(NSString*)expirYear cvvCode:(NSString*)cvvCode;

//Request to get the balance and transaction information
- (NSURLRequest*) generateBalanceURLRequest;

//Is the card valid
- (BOOL) isValidCard:(NSData*)webPageData;

- (NSString*) startingBalance:(NSData*)webPageData;
- (NSString*) currentBalance:(NSData*)webPageData;
- (NSMutableArray*) transactions:(NSData*)webPageData;

//Hides the card number - optional format: XXXX-XXXX-XXXX-1234
- (NSString*) hiddenCardNumberFormat;

//NSCoding delegates
- (id) initWithCoder:(NSCoder *)aDecoder;
- (void) encodeWithCoder:(NSCoder *)aCoder;

@end
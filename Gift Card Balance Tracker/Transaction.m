//
//  Transaction.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

- (instancetype)  initWithEverything:(NSString *)time nameAndLoc:(NSString *)nameAndLoc debitAmount:(NSString *)debitAmount
{
    self = [super init];
    
    if(self) {
        self.time = time;
        self.nameAndLocation = nameAndLoc;
        self.debitAmount = debitAmount;
    }
    
    return self;
}

@end
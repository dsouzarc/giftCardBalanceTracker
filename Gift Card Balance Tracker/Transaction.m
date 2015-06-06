//
//  Transaction.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

- (instancetype)  initWithEverything:(NSString *)date name:(NSString *)name location:(NSString *)location debitAmount:(NSString *)debitAmount
{
    self = [super init];
    
    if(self) {
        self.date = date;
        self.name = name;
        self.location = location;
        self.debitAmount = debitAmount;
    }
    
    return self;
}

@end

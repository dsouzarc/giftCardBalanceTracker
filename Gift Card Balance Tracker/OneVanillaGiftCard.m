
//
//  OneVanillaGiftCard.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "OneVanillaGiftCard.h"

@implementation OneVanillaGiftCard

- (instancetype) initWithEverything:(NSString *)cardNumber expirMonth:(NSString *)expirMonth expirYear:(NSString *)expirYear cvvCode:(NSString *)cvvCode
{
    self = [super init];
    
    if(self) {
        self.cardNumber = cardNumber;
        self.expirMonth = expirMonth;
        self.expirYear = expirYear;
        self.cvvCode = cvvCode;
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cardNumber forKey:@"cardNumber"];
    [aCoder encodeObject:self.expirMonth forKey:@"expirMonth"];
    [aCoder encodeObject:self.expirYear forKey:@"expirYear"];
    [aCoder encodeObject:self.cvvCode forKey:@"cvvCode"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithEverything:[aDecoder decodeObjectForKey:@"cardNumber"]
                         expirMonth:[aDecoder decodeObjectForKey:@"expirMonth"]
                          expirYear:[aDecoder decodeObjectForKey:@"expirYear"]
                            cvvCode:[aDecoder decodeObjectForKey:@"cvvCode"]];
}

@end

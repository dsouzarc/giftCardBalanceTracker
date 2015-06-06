//
//  OneVanillaGiftCard.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface OneVanillaGiftCard : NSObject<Card>

@property (strong, nonatomic, readwrite) NSString *cardNumber;

@property (strong, nonatomic, readwrite) NSString *expirMonth;
@property (strong, nonatomic, readwrite) NSString *expirYear;
@property (strong, nonatomic, readwrite) NSString *cvvCode;

@end

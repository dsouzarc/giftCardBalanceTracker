//
//  OneVanillaGiftCard.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneVanillaGiftCard : NSObject <NSCoding>

- (instancetype) initWithEverything:(NSString*)cardNumber expirMonth:(NSString*)expirMonth expirYear:(NSString*)expirYear cvvCode:(NSString*)cvvCode;

@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *expirMonth;
@property (strong, nonatomic) NSString *expirYear;
@property (strong, nonatomic) NSString *cvvCode;

@end

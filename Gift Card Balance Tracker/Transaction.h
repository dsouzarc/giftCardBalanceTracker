//
//  Transaction.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *nameAndLocation;
@property (strong, nonatomic) NSString *debitAmount;

- (instancetype) initWithEverything:(NSString*)time nameAndLoc:(NSString*)nameAndLoc
                        debitAmount:(NSString*)debitAmount;

@end

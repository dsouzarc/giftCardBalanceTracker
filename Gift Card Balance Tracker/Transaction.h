//
//  Transaction.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *debitAmount;

- (instancetype) initWithEverything:(NSString*)date name:(NSString*)name location:(NSString*)location debitAmount:(NSString*)debitAmount;

@end

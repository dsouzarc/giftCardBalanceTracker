//
//  TransactionTableViewCell.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/7/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UITextView *transactionTitle;
@property (strong, nonatomic) IBOutlet UILabel *transactionDate;
@property (strong, nonatomic) IBOutlet UILabel *transactionCost;
@end

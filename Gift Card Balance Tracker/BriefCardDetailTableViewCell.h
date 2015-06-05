//
//  BriefCardDetailTableViewCell.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/5/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BriefCardDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentBalanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *startBalanceLabel;

@end

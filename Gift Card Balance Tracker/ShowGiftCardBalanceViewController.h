//
//  ShowGiftCardBalanceViewController.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"

@interface ShowGiftCardBalanceViewController : ViewController <UITableViewDataSource, UITableViewDataSource>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil giftCard:(id<Card>)giftCard;

@end
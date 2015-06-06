//
//  AllCardsViewController.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/5/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"
#import "AddNewCardViewController.h"
#import "BriefCardDetailTableViewCell.h"

@interface AllCardsViewController : ViewController <UITableViewDataSource, UITableViewDelegate, AddNewCardViewControllerDelegate>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                       giftCards:(NSMutableArray*)giftcards;

@end

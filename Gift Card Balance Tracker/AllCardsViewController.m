//
//  AllCardsViewController.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/5/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "AllCardsViewController.h"

@interface AllCardsViewController ()

@property (strong, nonatomic) NSMutableArray *giftCards;
@property (strong, nonatomic) IBOutlet UITableView *allCardsTableView;

- (IBAction)addButton:(id)sender;
- (IBAction)editButton:(id)sender;

@end

@implementation AllCardsViewController

static NSString *allCardsIdentifier = @"BriefCardDetailCell";

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil giftCards:(NSMutableArray *)giftcards
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.giftCards = giftcards;
    }
    
    return self;
}

- (void)viewDidLoad {
    [self.allCardsTableView registerNib:[UINib nibWithNibName:@"BriefCardDetailTableViewCell"
                                                       bundle:[NSBundle mainBundle]] forCellReuseIdentifier:allCardsIdentifier];
    [super viewDidLoad];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.giftCards.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BriefCardDetailTableViewCell *cell = [self.allCardsTableView dequeueReusableCellWithIdentifier:allCardsIdentifier];
    
    if(!cell) {
        cell = [[BriefCardDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:allCardsIdentifier];
        NSLog(@"Initialized");
    }
    
    id<Card> card = (id<Card>) self.giftCards[indexPath.row];
    
    cell.cardNumberLabel.text = [self formatCardNumber:card.cardNumber];
    
    [NSURLConnection sendAsynchronousRequest:card.generateBalanceURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(error) {
            NSString *title = [NSString stringWithFormat:@"Error: %@", [card.cardNumber substringFromIndex:card.cardNumber.length - 5]];
            [self showAlert:title alertMessage:error.description buttonName:@"Ok"];
            return;
        }
        
        NSString *startBalance = [card startingBalance:data];
        NSString *currentBalance = [card currentBalance:data];
        
        cell.startBalanceLabel.text = [NSString stringWithFormat:@"Start Balance: %@", startBalance];
        cell.currentBalanceLabel.text = [NSString stringWithFormat:@"Current: %@", currentBalance];
        
        cell.startBalanceLabel.adjustsFontSizeToFitWidth = YES;
        cell.currentBalanceLabel.adjustsFontSizeToFitWidth = YES;
    }];
    
    return cell;
}

- (void) showAlert:(NSString*)alertTitle alertMessage:(NSString*)alertMessage buttonName:(NSString*)buttonName {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:buttonName
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSString*) formatCardNumber:(NSString*)cardNumber
{
    NSString *last4 = [cardNumber substringFromIndex:cardNumber.length - 5];
    return [NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@", last4];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


- (IBAction)addButton:(id)sender {

}

- (IBAction)editButton:(id)sender {

}
@end

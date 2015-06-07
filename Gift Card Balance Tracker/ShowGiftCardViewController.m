//
//  ShowGiftCardBalanceViewController.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ShowGiftCardBalanceViewController.h"

@interface ShowGiftCardBalanceViewController ()

@property (strong, nonatomic) IBOutlet UIButton *cardNumber;
@property (strong, nonatomic) IBOutlet UIButton *expirationMonth;
@property (strong, nonatomic) IBOutlet UIButton *expirationYear;
@property (strong, nonatomic) IBOutlet UILabel *currentBalance;
@property (strong, nonatomic) IBOutlet UILabel *initialBalance;

@property (strong, nonatomic) IBOutlet UIButton *cvvCode;
@property (strong, nonatomic) id<Card> giftCard;
@property (strong, nonatomic) NSMutableArray *transactions;
@property (strong, nonatomic) IBOutlet UITableView *transactionsTableView;

- (IBAction)back:(id)sender;

@end

static NSString *transactionIdentifier = @"TransactionCell";

@implementation ShowGiftCardBalanceViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil giftCard:(id<Card>)giftCard
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.giftCard = giftCard;
        self.transactions = [self.giftCard transactions:self.giftCard.tempDataStore];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.transactionsTableView registerNib:[UINib nibWithNibName:@"TransactionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:transactionIdentifier];
    [self.giftCard transactions:self.giftCard.tempDataStore];
    
    [self.cardNumber setTitle:[self.giftCard hiddenCardNumberFormat] forState:UIControlStateNormal];
    [self.expirationMonth setTitle:@"MM" forState:UIControlStateNormal];
    [self.expirationYear setTitle:@"YY" forState:UIControlStateNormal];
    [self.cvvCode setTitle:@"XXX" forState:UIControlStateNormal];
    
    self.initialBalance.text = [self.giftCard startingBalance:self.giftCard.tempDataStore];
    self.currentBalance.text = [self.giftCard currentBalance:self.giftCard.tempDataStore];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.transactions.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionTableViewCell *cell = [self.transactionsTableView dequeueReusableCellWithIdentifier:transactionIdentifier];
    
    if(!cell) {
        cell = [[TransactionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:transactionIdentifier];
    }
    
    Transaction *transaction = (Transaction*)self.transactions[indexPath.row];
    
    cell.transactionTitle.text = transaction.nameAndLocation;
    cell.transactionDate.text = transaction.time;
    cell.transactionCost.text = transaction.debitAmount;

    cell.transactionDate.adjustsFontSizeToFitWidth = YES;
    cell.transactionCost.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}


- (IBAction)cvvCode:(id)sender {
    if([self.cvvCode.titleLabel.text isEqualToString:@"XXX"]) {
        [self.cvvCode setTitle:self.giftCard.cvvCode forState:UIControlStateNormal];
    }
    else {
        [self.cvvCode setTitle:@"XXX" forState:UIControlStateNormal];
    }
}

- (IBAction)expirationYear:(id)sender {
    if([self.expirationYear.titleLabel.text isEqualToString:@"YY"]) {
        [self.expirationYear setTitle:self.giftCard.expirYear forState:UIControlStateNormal];
    }
    else {
        [self.expirationYear setTitle:@"YY" forState:UIControlStateNormal];
    }
}

- (IBAction)expirationMonth:(id)sender {
    if([self.expirationMonth.titleLabel.text isEqualToString:@"MM"]) {
        [self.expirationMonth setTitle:self.giftCard.expirMonth forState:UIControlStateNormal];
    }
    else {
        [self.expirationMonth setTitle:@"MM" forState:UIControlStateNormal];
    }
}

- (IBAction)cardNumber:(id)sender {
    if([self.cardNumber.titleLabel.text isEqualToString:[self.giftCard hiddenCardNumberFormat]]) {
        [self.cardNumber setTitle:self.giftCard.cardNumber forState:UIControlStateNormal];
    }
    else {
        [self.cardNumber setTitle:[self.giftCard hiddenCardNumberFormat] forState:UIControlStateNormal];
    }
}

- (IBAction)back:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
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

@property (strong, nonatomic) IBOutlet UIButton *cvvCode;
@property (strong, nonatomic) id<Card> giftCard;
@property (strong, nonatomic) IBOutlet UITableView *transactionsTableView;

- (IBAction)back:(id)sender;

@end

@implementation ShowGiftCardBalanceViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil giftCard:(id<Card>)giftCard
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.giftCard = giftCard;

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.giftCard transactions:self.giftCard.tempDataStore];
    
    [self.cardNumber setTitle:[self.giftCard hiddenCardNumberFormat] forState:UIControlStateNormal];
    [self.expirationMonth setTitle:@"MM" forState:UIControlStateNormal];
    [self.expirationYear setTitle:@"YY" forState:UIControlStateNormal];
    [self.cvvCode setTitle:@"XXX" forState:UIControlStateNormal];
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
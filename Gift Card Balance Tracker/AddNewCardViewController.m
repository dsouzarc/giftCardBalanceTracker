//
//  AddNewCardViewController.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "AddNewCardViewController.h"

@interface AddNewCardViewController ()

@property (strong, nonatomic) IBOutlet UIButton *addCardButton;
@property (strong, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *expirationMonthTextField;
@property (strong, nonatomic) IBOutlet UITextField *expirationYearTextField;
@property (strong, nonatomic) IBOutlet UITextField *cvvCodeTextField;

@end

@implementation AddNewCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)addCardButton:(id)sender {
    
    OneVanillaGiftCard *card = [[OneVanillaGiftCard alloc]
                                initWithEverything:self.cardNumberTextField.text
                                expirMonth:self.expirationMonthTextField.text
                                expirYear:self.expirationYearTextField.text
                                cvvCode:self.cvvCodeTextField.text];
    
    [self.delegate addNewCardViewController:self newCard:card];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButton:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

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
@property (strong, nonatomic) PQFBouncingBalls *bouncingBalls;

@property (strong, nonatomic) UIAlertView *addCardAlertView;
@property (strong, nonatomic) OneVanillaGiftCard *giftCard;

@end

@implementation AddNewCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Remove keyboard when area outside textfield is tapped
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)addCardButton:(id)sender {
    
    self.giftCard = [[OneVanillaGiftCard alloc]
                                initWithEverything:self.cardNumberTextField.text
                                expirMonth:self.expirationMonthTextField.text
                                expirYear:self.expirationYearTextField.text
                                cvvCode:self.cvvCodeTextField.text];
    
    if(!self.bouncingBalls) {
        self.bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
        self.bouncingBalls.loaderColor = [UIColor blueColor];
    }
    
    [self.bouncingBalls show];
    
    [NSURLConnection sendAsynchronousRequest:self.giftCard.generateBalanceURLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [self.bouncingBalls hide];
         
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"%@", string);
         
         //Something goes wrong (like no Internet connection)
         if(error) {
             NSString *title = [self.giftCard hiddenCardNumberFormat];
             [self showAlert:title alertMessage:error.description buttonName:@"Ok"];
             return;
         }
         
         NSString *startBalance = [self.giftCard startingBalance:data];
         NSString *currentBalance = [self.giftCard currentBalance:data];
         
         //If we can't find a valid start or current balance
         if(!startBalance || startBalance.length <= 2 || currentBalance) {
             
             //Add the card anyway?
             self.addCardAlertView = [[UIAlertView alloc] initWithTitle:@"Incorrect Information"
                                                                message:@"It doesn't seem like we could find any debit card with that information. Would you like to add it anyway?"
                                                               delegate:self
                                                      cancelButtonTitle:@"I'll re-enter the information"
                                                      otherButtonTitles:@"Add card anyway", nil];
             [self.addCardAlertView show];
             return;
         }
         
         //Found a valid balance
         else {
             [self addCard];
         }
     }];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.addCardAlertView) {

        //Add the card anyway
        if(buttonIndex == 1) {;
            [self addCard];
        }
    }
}

- (void) addCard {
    [self.delegate addNewCardViewController:self newCard:self.giftCard];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButton:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showAlert:(NSString*)alertTitle alertMessage:(NSString*)alertMessage buttonName:(NSString*)buttonName {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:buttonName
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

@end

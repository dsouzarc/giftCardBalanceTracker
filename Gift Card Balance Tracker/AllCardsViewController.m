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
@property (strong, nonatomic) AddNewCardViewController *addCardViewController;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) ShowGiftCardBalanceViewController *showBalance;

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
    
    //SWIPE TO REFRESH
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshGiftCards) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor colorWithRed:(254/255.0) green:(153/255.0) blue:(0/255.0) alpha:1];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing gift card balances"];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.allCardsTableView;
    tableViewController.refreshControl = self.refreshControl;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.giftCards.count;
}

- (void) refreshGiftCards
{
    [self.allCardsTableView reloadData];
    
    [self.refreshControl endRefreshing];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BriefCardDetailTableViewCell *cell = [self.allCardsTableView dequeueReusableCellWithIdentifier:allCardsIdentifier];
    
    if(!cell) {
        cell = [[BriefCardDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:allCardsIdentifier];
    }
    
    id<Card> card = (id<Card>) self.giftCards[indexPath.row];
    
    cell.cardNumberLabel.text = [self formatCardNumber:card.cardNumber];

    [NSURLConnection sendAsynchronousRequest:card.generateBalanceURLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"FOR CARD: %@", card.cardNumber);
        NSLog(@"%@", string);
        
        if(error) {
            NSString *title = [NSString stringWithFormat:@"Error: %@",
                               [card.cardNumber substringFromIndex:card.cardNumber.length - 5]];
            [self showAlert:title alertMessage:error.description buttonName:@"Ok"];
            return;
        }
                            
        NSString *startBalance = [card startingBalance:data];
        NSString *currentBalance = [card currentBalance:data];
        
        if(!startBalance || startBalance.length <= 2) {
            startBalance = card.startingBalance;
        }
        else {
            card.startingBalance = startBalance;
        }
        
        if(!currentBalance || currentBalance.length == 0) {
            currentBalance = card.currentBalance;
        }
        else {
            card.currentBalance = currentBalance;
        }
                               
        cell.startBalanceLabel.text = [NSString stringWithFormat:@"Start Balance: %@", startBalance];
        cell.currentBalanceLabel.text = [NSString stringWithFormat:@"Current: %@", currentBalance];
        
        cell.startBalanceLabel.adjustsFontSizeToFitWidth = YES;
        cell.currentBalanceLabel.adjustsFontSizeToFitWidth = YES;
    }];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<Card> chosen = self.giftCards[indexPath.row];
    self.showBalance = [[ShowGiftCardBalanceViewController alloc] initWithNibName:@"ShowGiftCardBalanceViewController" bundle:[NSBundle mainBundle] giftCard:chosen];
    self.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:self.showBalance animated:YES completion:nil];
}

- (void) saveCards
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.giftCards];
    [defaults setObject:data forKey:SAVED_CARDS];
    [defaults synchronize];
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
    self.addCardViewController = [[AddNewCardViewController alloc] initWithNibName:@"AddNewCardViewController" bundle:[NSBundle mainBundle]];
    self.addCardViewController.delegate = self;
    self.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:self.addCardViewController animated:YES completion:nil];
}

- (void) addNewCardViewController:(AddNewCardViewController *)controller newCard:(id<Card>)newCard
{
    [self.giftCards addObject:newCard];
    [self refreshGiftCards];
    
    [self saveCards];
}

- (IBAction)editButton:(id)sender {

}
@end

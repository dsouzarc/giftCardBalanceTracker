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
@property (strong, nonatomic) PQFCirclesInTriangle *loadingAnimation;

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
    
    //For the custom table view cell
    [self.allCardsTableView registerNib:[UINib nibWithNibName:@"BriefCardDetailTableViewCell"
                                                       bundle:[NSBundle mainBundle]] forCellReuseIdentifier:allCardsIdentifier];
    
    //Loading animation
    self.loadingAnimation = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
    self.loadingAnimation.loaderColor = [UIColor blueColor];
    self.loadingAnimation.borderWidth = 5.0;
    self.loadingAnimation.maxDiam = 200.0;
    [self.loadingAnimation show];

    
    //Swipe to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshGiftCards)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor colorWithRed:(254/255.0) green:(153/255.0)
                                                     blue:(0/255.0) alpha:1];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]
                                           initWithString:@"Refreshing gift card balances"];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.allCardsTableView;
    tableViewController.refreshControl = self.refreshControl;
    
    [super viewDidLoad];
}


- (IBAction)editButton:(id)sender {
    
}


/****************************/
//    ADDING A NEW CARD
/****************************/

- (IBAction)addButton:(id)sender {
    self.addCardViewController = [[AddNewCardViewController alloc] initWithNibName:@"AddNewCardViewController" bundle:[NSBundle mainBundle]];
    self.addCardViewController.delegate = self;
    self.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:self.addCardViewController animated:YES completion:nil];
}

/* Saves all the cards when a new one is added */
- (void) saveCards
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.giftCards];
    [defaults setObject:data forKey:SAVED_CARDS];
    [defaults synchronize];
}

/** When a new card is added from the view controller */
- (void) addNewCardViewController:(AddNewCardViewController *)controller newCard:(id<Card>)newCard
{
    [self.giftCards addObject:newCard];
    [self refreshGiftCards];
    [self saveCards];
}


/****************************/
//    TABLEVIEW DELEGATES
/****************************/

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BriefCardDetailTableViewCell *cell = [self.allCardsTableView dequeueReusableCellWithIdentifier:allCardsIdentifier];
    
    if(!cell) {
        cell = [[BriefCardDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:allCardsIdentifier];
    }
    
    id<Card> card = (id<Card>) self.giftCards[indexPath.row];
    
    cell.cardNumberLabel.text = [card hiddenCardNumberFormat];
    
    [NSURLConnection sendAsynchronousRequest:card.generateBalanceURLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         //If it's the last card, hide the loading animation cause we got everything
         if(indexPath.row == self.giftCards.count - 1) {
             [self.loadingAnimation hide];
         }
         
         //NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
         //NSLog(@"%@", string);
         
         //Problem getting card info
         if(error) {
             NSString *title = [card hiddenCardNumberFormat];
             [self showAlert:title alertMessage:error.description buttonName:@"Ok"];
             return;
         }
         
         NSString *startBalance = [card startingBalance:data];
         NSString *currentBalance = [card currentBalance:data];
         
         //Every now and then, the API won't work, so use the cached info
         if(!startBalance || startBalance.length <= 2) {
             startBalance = card.startingBalance;
         }
         
         //If it does work, cache the use info.
         else {
             card.startingBalance = startBalance;
             card.tempDataStore = data;
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

/** Show the gift card balance and previous transactions */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<Card> chosen = self.giftCards[indexPath.row];
    self.showBalance = [[ShowGiftCardBalanceViewController alloc]
                        initWithNibName:@"ShowGiftCardBalanceViewController"
                        bundle:[NSBundle mainBundle]
                        giftCard:chosen];
    self.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:self.showBalance animated:YES completion:nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.giftCards.count;
}


/****************************/
//    Misc. Methods
/****************************/

- (void) refreshGiftCards
{
    [self.loadingAnimation show];
    [self.allCardsTableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void) showAlert:(NSString*)alertTitle alertMessage:(NSString*)alertMessage buttonName:(NSString*)buttonName {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:buttonName
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end

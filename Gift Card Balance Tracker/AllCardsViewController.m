//
//  AllCardsViewController.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/5/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "AllCardsViewController.h"

static NSString const *allCardsIdentifier = @"BriefCardDetailCell";

@interface AllCardsViewController ()

@property (strong, nonatomic) NSMutableArray *giftCards;
@property (strong, nonatomic) IBOutlet UITableView *allCardsTableView;

- (IBAction)addButton:(id)sender;
- (IBAction)editButton:(id)sender;

@end

@implementation AllCardsViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil giftCards:(NSMutableArray *)giftcards
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.giftCards = giftcards;
        
        [self.allCardsTableView registerNib:[UINib nibWithNibName:@"BriefCardDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:allCardsIdentifier];
    }
    
    return self;
}

- (void)viewDidLoad {
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
        cell = [[BriefCardDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCardsIdentifier];
    }
    
    OneVanillaGiftCard *card = (OneVanillaGiftCard*) self.giftCards[indexPath.row];
    
    cell.cardNumberLabel.text = [self formatCardNumber:card.cardNumber];
    
    return cell;
}

- (NSString*) formatCardNumber:(NSString*)cardNumber
{
    NSString *last4 = [cardNumber substringFromIndex:cardNumber.length - 5];
    return [NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@", last4];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}


- (IBAction)addButton:(id)sender {

}

- (IBAction)editButton:(id)sender {

}
@end

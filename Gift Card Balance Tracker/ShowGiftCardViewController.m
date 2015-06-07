//
//  ShowGiftCardBalanceViewController.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ShowGiftCardBalanceViewController.h"

@interface ShowGiftCardBalanceViewController ()
- (IBAction)back:(id)sender;

@property (strong, nonatomic) id<Card> giftCard;

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

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Temp" ofType:@"html"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [self.giftCard transactions:data];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Data received");
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strData);
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"FAILED: %@", error.description);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished loading");
}

- (IBAction)back:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
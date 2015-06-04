//
//  ShowGiftCardBalanceViewController.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ShowGiftCardBalanceViewController.h"

@interface ShowGiftCardBalanceViewController ()

@property (strong, nonatomic) OneVanillaGiftCard *giftCard;

@end

@implementation ShowGiftCardBalanceViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil giftCard:(OneVanillaGiftCard *)giftCard
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.giftCard = giftCard;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[self.giftCard generateBalanceURLRequest] delegate:self];
    
    if(conn) {
        NSLog(@"Successful connection");
    }
    else {
        NSLog(@"Bad connection");
    }
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

@end
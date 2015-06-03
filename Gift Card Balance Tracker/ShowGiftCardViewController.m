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

    NSString *url = @"https://www.onevanilla.com/onevanilla/login.html";
    NSString *post = [NSString stringWithFormat:@"csrfToken=jxEwNYITEGXsNQ80bGHkOocCXrwHOOKa&cardNumber=%@&mm=%@&yy=%@&cvv=%@", self.giftCard.cardNumber, self.giftCard.expirMonth, self.giftCard.expirYear, self.giftCard.cvvCode];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"www.onevanilla.com" forHTTPHeaderField:@"Host"];
    [request setValue:@"keep-alive" forHTTPHeaderField:@"Proxy-Connection"];
    [request setValue:@"gzip, deflat" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"en-us" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Origin" forHTTPHeaderField:@"https://www.onevanilla.com"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12F70 Safari/600.1.4" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"https://www.onevanilla.com/onevanilla/" forHTTPHeaderField:@"Referer"];
    [request setValue:@"DNT" forHTTPHeaderField:@"1"];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
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
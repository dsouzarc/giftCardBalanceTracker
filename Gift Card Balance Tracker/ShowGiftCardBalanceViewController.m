//
//  ShowGiftCardBalanceViewController.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ShowGiftCardBalanceViewController.h"

@interface ShowGiftCardBalanceViewController ()

@property (strong, nonatomic) UIWebView *internalWebView;

@end

@implementation ShowGiftCardBalanceViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        self.internalWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *URL = @"https://www.onevanilla.com/onevanilla/";
    
    /** 
     curl -H "Content-Type: application/x-www-form-urlencoded" --data-binary "csrfToken=jxEwNYITEGXsNQ80bGHkOocCXrwHOOKa&cardNumber=4941599204328210&mm=07&yy=23&cvv=098" https://www.onevanilla.com/onevanilla/login.html;jsessionid=yfJY0+6CqHhJ-5PP0IivsLYd.undefined
     */
    
    NSString *url = @"https://www.onevanilla.com/onevanilla/login.html";
    
    NSString *token = @"jxEwNYITEGXsNQ80bGHkOocCXrwHOOKa";
    NSString *cardNumber = @"4941599268892242";
    NSString *expMonth = @"07";
    NSString *expYear = @"23";
    NSString *cvv = @"701";
    
    NSString *post = @"csrfToken=jxEwNYITEGXsNQ80bGHkOocCXrwHOOKa&cardNumber=4941599204328210&mm=07&yy=23&cvv=098";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSLog(@"POST: %@", post);
    
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

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Webview failed to load: %@", error.description);
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Webview starting to load");
}


- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Load finished: %@", webView.request.URL.absoluteString);
    

    
    /*[self injectInformation:@"cardNumber" value:cardNumber];
    [self injectInformation:@"mm" value:expMonth];
    [self injectInformation:@"yy" value:expYear];
    [self injectInformation:@"cvv" value:cvv];
    
    [self.internalWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('go')[0].click()"];*/
    
    
}

- (void) injectInformation:(NSString*)elementName value:(NSString*)value
{
    NSString *javaScriptCall = [NSString stringWithFormat:@"document.getElementsByName('%@')[0].value=%@", elementName, value];
    [self.internalWebView stringByEvaluatingJavaScriptFromString:javaScriptCall];
}


@end

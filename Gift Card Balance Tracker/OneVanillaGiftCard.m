
//
//  OneVanillaGiftCard.m
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/3/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "OneVanillaGiftCard.h"
#import "TFHpple.h"

static NSString const *LOGIN_URL = @"https://www.onevanilla.com/onevanilla/login.html";
static NSString const *CSRF_TOKEN = @"jxEwNYITEGXsNQ80bGHkOocCXrwHOOKa";

@implementation OneVanillaGiftCard

- (instancetype) initWithEverything:(NSString *)cardNumber expirMonth:(NSString *)expirMonth expirYear:(NSString *)expirYear cvvCode:(NSString *)cvvCode
{
    self = [super init];
    
    if(self) {
        self.cardNumber = cardNumber;
        self.expirMonth = expirMonth;
        self.expirYear = expirYear;
        self.cvvCode = cvvCode;
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cardNumber forKey:@"cardNumber"];
    [aCoder encodeObject:self.expirMonth forKey:@"expirMonth"];
    [aCoder encodeObject:self.expirYear forKey:@"expirYear"];
    [aCoder encodeObject:self.cvvCode forKey:@"cvvCode"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithEverything:[aDecoder decodeObjectForKey:@"cardNumber"]
                         expirMonth:[aDecoder decodeObjectForKey:@"expirMonth"]
                          expirYear:[aDecoder decodeObjectForKey:@"expirYear"]
                            cvvCode:[aDecoder decodeObjectForKey:@"cvvCode"]];
}

- (NSString*) currentBalance:(NSData*)webPageData
{
    TFHpple *httpl = [[TFHpple alloc] initWithHTMLData:webPageData];
    
    NSString *tutorialsXpathQueryString = @"//table[@id='card_info']/tr/td";
    NSArray *tutorialsNodes = [httpl searchWithXPathQuery:tutorialsXpathQueryString];
    
    BOOL availableBalanceIsNext = NO;
    for(TFHppleElement *element in tutorialsNodes) {
        if(availableBalanceIsNext) {
            return element.content;
        }
        if([element.content isEqualToString:@"Available balance"]) {
            availableBalanceIsNext = YES;
        }
    }
    return @"";
}

- (NSString*) startingBalance:(NSData*)webPageData
{
    TFHpple *httpl = [[TFHpple alloc] initWithHTMLData:webPageData];
    
    NSString *tutorialsXpathQueryString = @"//table[@id='card_info']/tr/td";
    NSArray *tutorialsNodes = [httpl searchWithXPathQuery:tutorialsXpathQueryString];
    
    BOOL startingBalanceIsNext = NO;
    for(TFHppleElement *element in tutorialsNodes) {
        if(startingBalanceIsNext) {
            return element.content;
        }
        if([element.content isEqualToString:@"Starting balance"]) {
            startingBalanceIsNext = YES;
        }
    }
    return @"";
}

- (NSString*) hiddenCardNumberFormat
{
    NSString *last4 = [self.cardNumber substringFromIndex:self.cardNumber.length - 4];
    return [NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@", last4];
}

- (BOOL) isValidCard:(NSData *)webPageData
{
    TFHpple *httpl = [[TFHpple alloc] initWithHTMLData:webPageData];
    
    NSString *tutorialsXpathQueryString = @"//table[@id='card_info']/tr/td/td";
    NSArray *tutorialsNodes = [httpl searchWithXPathQuery:tutorialsXpathQueryString];
    
    if(!tutorialsNodes || tutorialsNodes.count == 0) {
        return NO;
    }
    return YES;
}


- (NSMutableArray*) transactions:(NSData *)webPageData
{
    NSMutableArray *transactions = [[NSMutableArray alloc] init];
    
    //There's a wrong tag so we have to fix it. Might as well move newlines/spaces as well
    NSString *string = [[NSString alloc] initWithData:webPageData encoding:NSASCIIStringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"  " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</body>" withString:@"</tbody>"]; // <-- Typo some dev made :'(
    webPageData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *httpl = [[TFHpple alloc] initWithHTMLData:webPageData];

    NSString *queryString = @"//table/tbody/tr/td";
    NSArray *queryNodes = [httpl searchWithXPathQuery:queryString];

    for(int i = 0; i < queryNodes.count - 3; i+=4) {
        
        NSString *time = [self nicelyFormattedString:queryNodes[i]];
        NSString *place = [self nicelyFormattedString:queryNodes[i + 1]];
        NSString *debitAmount = [self nicelyFormattedString:queryNodes[i + 2]];
        NSString *creditAmount = [self nicelyFormattedString:queryNodes[i + 3]];
        
        if(debitAmount.length >= 2 || creditAmount.length >= 2) {
            Transaction *transaction = [[Transaction alloc] initWithEverything:time nameAndLoc:place debitAmount:debitAmount];
            [transactions addObject:transaction];
             NSLog(@"Yo: \t%@\t%@\t%@\t%@", time, place, debitAmount, creditAmount);
        }
    }
    
    return transactions;
}

- (NSString*) nicelyFormattedString:(NSObject*)object
{
    TFHppleElement *element = (TFHppleElement*)object;
    NSString *result = element.content;
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"  " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSArray* words = [result componentsSeparatedByCharactersInSet :[NSCharacterSet newlineCharacterSet]];
    return [words componentsJoinedByString:@""];
}

- (NSString*) generateRandomToken
{
    NSMutableString *token = [[NSMutableString alloc] initWithString:CSRF_TOKEN];
    
    //Change a few characters at random
    for(int i = 0; i < 3; i++) {
        NSInteger randomCharIndex = arc4random_uniform((int) token.length);
        
        NSRange rangeToReplace = NSMakeRange(randomCharIndex, 1);
        
        [token replaceCharactersInRange:rangeToReplace withString:[NSString stringWithFormat:@"%c", [self getRandomChar]]];
    }
    
    return token;
}

- (NSURLRequest*) generateBalanceURLRequest
{
    NSString *url = @"https://www.onevanilla.com/onevanilla/login.html";
    
    NSMutableString *post = [[NSMutableString alloc] init];
    [post appendString:@"csrfToken="];
    [post appendString:[self generateRandomToken]];
    [post appendString:@"&cardNumber="];
    [post appendString:self.cardNumber];
    [post appendString:@"&mm="];
    [post appendString:self.expirMonth];
    [post appendString:@"&yy="];
    [post appendString:self.expirYear];
    [post appendString:@"&cvv="];
    [post appendString:self.cvvCode];
    
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
    //[request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12F70 Safari/600.1.4" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"https://www.onevanilla.com/onevanilla/" forHTTPHeaderField:@"Referer"];
    [request setValue:@"DNT" forHTTPHeaderField:@"1"];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    return request;
}

- (char)getRandomChar {
    return (char) (arc4random_uniform(26) + 'a');
}

@end

//
//  OAuthRequestController.m
//  IoTally
//
//  Created by Levent Ali on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OAuthRequestController.h"

#import "PachubeAppCredentials.h"

@implementation OAuthRequestController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[self authenticateOnPachube]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSURLRequest *)authenticateOnPachube {
    NSURL *fullURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/authenticate?client_id=%@", PBsiteEndpoint, PBoAuthAppId]];
    NSMutableURLRequest *authRequest = [NSMutableURLRequest requestWithURL:fullURL];
    [authRequest setHTTPMethod:@"GET"];
    return [authRequest copy];
}

- (void)verifyWithCode:(NSString *)accessCode {
    responseData = [NSMutableData data];
    NSURL *fullURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/token?client_id=%@", PBsiteEndpoint, PBoAuthAppId]];
    NSLog(@"token exchange dance: %@", [fullURL absoluteString]);
    NSMutableURLRequest *tokenRequest = [NSMutableURLRequest requestWithURL:fullURL];
    [tokenRequest setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"code=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", accessCode, PBoAuthAppSecret, PBoauthRedirectURI];
    NSLog(@"post string: %@", postString);
    [tokenRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:tokenRequest delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"status code: %d", statusCode);
    responseHeaders = [(NSHTTPURLResponse *)response allHeaderFields];
    NSLog(@"headers: %@", [responseHeaders description]);
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//	currentTallyField.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    NSLog(@"error");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if([responseString length] > 1) {
        [self extractApiKey:responseString];
    }
    else
    {
        NSArray *locationHeader = [[responseHeaders objectForKey:@"Location"] componentsSeparatedByString:@"/"];
        NSLog(@"%@", [locationHeader lastObject]);
        feedId = [locationHeader lastObject];
        [userDefaults setObject:feedId forKey:@"feedId"];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)extractApiKey:(NSString *)responseString {
    NSDictionary *oauthAuthorisation = [responseString JSONValue];
    NSLog(responseString);
    if ([oauthAuthorisation objectForKey:@"access_token"]) {
        apiKey = [oauthAuthorisation objectForKey:@"access_token"];
        NSLog(@"found: %@", apiKey);
        userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:apiKey forKey:@"apiKey"];
        NSString *feedId = [userDefaults objectForKey:@"feedId"];
        if(feedId == nil)
        {
            [self createFeed];
        }
        else
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

-(void)createFeed {
    responseData = [NSMutableData data];
    NSLog(@"Create with key : %@", apiKey);
    NSURL *fullURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/feeds.json?key=%@", PBapiEndpoint, apiKey]];
    NSMutableURLRequest *newFeedRequest = [NSMutableURLRequest requestWithURL:fullURL];
    [newFeedRequest setHTTPMethod:@"POST"];
    NSString *postString = @"{\"title\":\"IoTally feed\",\"version\":\"1.0.0\"}";
    NSLog(@"post string: %@", postString);
    [newFeedRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:newFeedRequest delegate:self];
}

@end

@implementation OAuthRequestController (UIWebViewIntegration)
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if([[request.URL absoluteString] hasPrefix:PBoauthRedirectURI]) {
        [self extractCodeFromRedirectURL:request.URL];
        return NO;
    }
    NSLog([request.URL absoluteString]);
    return YES;
}


- (void)extractCodeFromRedirectURL:(NSURL *)url {
    NSArray *queryParams = [[url query] componentsSeparatedByString:@"&"];
    for (NSString* kvp in queryParams)
    {
        NSRange pos = [kvp rangeOfString:@"="];
        NSString *key;
        NSString *val;
        if(pos.location == NSNotFound)
        {
            key = kvp;
            val = @"";
        }
        else
        {
            key = [kvp substringToIndex:pos.location];
            val = [kvp substringFromIndex:pos.location + pos.length];
        }
        if([key isEqualToString:@"code"])
        {
            [self verifyWithCode:val];
            
        }
    }
}

@end

// MUST REMOVE BEFORE SUBMISSION
// DISABLES SSL CERT
@interface NSURLRequest (NSURLRequestWithIgnoreSSL) 
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL) 
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}
@end
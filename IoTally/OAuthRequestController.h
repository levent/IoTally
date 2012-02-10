//
//  OAuthRequestController.h
//  IoTally
//
//  Created by Levent Ali on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@interface OAuthRequestController : UIViewController {
    NSString *apiKey;
    NSString *feedId;
    UIWebView *webView;
    NSMutableData *responseData;
    NSDictionary *responseHeaders;
    NSUserDefaults *userDefaults;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (NSURLRequest *)authenticateOnPachube;
- (void)verifyWithCode:(NSString *)accessCode;
- (void)extractApiKey:(NSString *)responseString;
- (void)createFeed;

@end

@interface OAuthRequestController (UIWebViewIntegration) <UIWebViewDelegate> {
    
}
- (void)extractCodeFromRedirectURL:(NSURL *)url;

@end
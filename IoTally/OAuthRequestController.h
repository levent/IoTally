//
//  OAuthRequestController.h
//  IoTally
//
//  Created by Levent Ali on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OAuthRequestController : UIViewController {
    UIWebView *webView;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (NSURLRequest *)authenticateOnPachube;

@end

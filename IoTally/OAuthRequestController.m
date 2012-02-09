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
    NSLog(@"https://pachube.com/oauth/authenticate?client_id=%@", PBoAuthAppId);
//    [NSString stringWithFormat:@"http://pachube.com/oauth/authenticate?client_id=%@", PBoAuthAppId];
    NSURL *fullURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://pachube.com/oauth/authenticate?client_id=%@", PBoAuthAppId]];
    NSMutableURLRequest *authRequest = [NSMutableURLRequest requestWithURL:fullURL];
    [authRequest setHTTPMethod:@"GET"];
    NSLog(@"FDSFDSA");
    return [authRequest copy];
}

@end

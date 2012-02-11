//
//  SecondViewController.m
//  IoTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "OAuthRequestController.h"

#import "PachubeAppCredentials.h"

@implementation SettingsViewController

@synthesize accessToken;

- (id)initWithNibNameAndFeed:(NSString *)nibNameOrNil feed:(Feed *)feed bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myFeed = feed;
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"157-wrench"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    // Reset Button stuff
    [resetTally setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetTally setTitleColor:[UIColor colorWithRed:0.196078 green:0.309804 blue:0.521569 alpha:1] forState:UIControlStateHighlighted];
    [resetTally setHighColor:[UIColor redColor]];
    [resetTally setLowColor:[UIColor redColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadSettings];
    if (myFeed.apiKey == nil || myFeed.feedId == nil) {
        [self beginAuthorisation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)loadSettings {
    [feedIdField setText:myFeed.feedId];
    [apiKeyField setText:myFeed.apiKey];
}

-(IBAction)saveSettings:(id)sender {
    if (feedIdField.text != (id)[NSNull null] && feedIdField.text.length != 0) {
        [myFeed saveFeedId:feedIdField.text];
    }
    [self backgroundClick:sender];
}

-(IBAction)setTallyToZero:(id)sender {
    NSString *url = [[NSString alloc] initWithFormat:@"%@/feeds/%@/datastreams/tally.csv?key=%@", kPBapiEndpoint, myFeed.feedId, myFeed.apiKey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    NSString *postString = @"0";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)backgroundClick:(id)sender {
    [feedIdField resignFirstResponder];
    [apiKeyField resignFirstResponder];
}

- (void)beginAuthorisation {
    NSLog(@"apikey: %@ feedid: %@", myFeed.apiKey, myFeed.feedId);
    OAuthRequestController *oauthController = [[OAuthRequestController alloc] initWithFeed:myFeed];
    [self presentModalViewController:oauthController animated:YES];
}

@end

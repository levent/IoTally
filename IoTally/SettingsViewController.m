//
//  SecondViewController.m
//  IoTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "OAuthRequestController.h"

NSString *AccessTokenSavePath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"OAuthAccessToken.cache"];
}

@implementation SettingsViewController

@synthesize accessToken;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    [feedIdField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"feedId"]];
    [apiKeyField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"]];
    feedId = [[NSUserDefaults standardUserDefaults] objectForKey:@"feedId"];
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    
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
    self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithFile:AccessTokenSavePath()];
    if (self.accessToken == nil) {
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

-(IBAction)saveSettings:(id)sender {
    if (feedIdField.text != (id)[NSNull null] && feedIdField.text.length != 0) {
        feedId = [[NSString alloc] initWithFormat:feedIdField.text];
        [feedIdField setText:feedId];
        NSUserDefaults *feedIdDefault = [NSUserDefaults standardUserDefaults];
        [feedIdDefault setObject:feedId forKey:@"feedId"];
    }
    if (apiKeyField.text != (id)[NSNull null] && apiKeyField.text.length != 0) {
        apiKey = [[NSString alloc] initWithFormat:apiKeyField.text];
        [apiKeyField setText:apiKey];
        NSUserDefaults *apiKeyDefault = [NSUserDefaults standardUserDefaults];
        [apiKeyDefault setObject:apiKey forKey:@"apiKey"];
    }
    
    [self backgroundClick:sender];
}

-(IBAction)setTallyToZero:(id)sender {
    NSString *url = [[NSString alloc] initWithFormat:@"http://api.pachube.com/v2/feeds/%@/datastreams/tally.csv?key=%@", feedId, apiKey];
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
    OAuthRequestController *oauthController = [[OAuthRequestController alloc] init];
    [self presentModalViewController:oauthController animated:YES];
}

@end

//
//  FirstViewController.m
//  IoTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TallyViewController.h"
#import "OAuthRequestController.h"
#import "PachubeAppCredentials.h"

@implementation TallyViewController
@synthesize currentTallyField;

- (id)initWithNibNameAndFeed:(NSString *)nibNameOrNil feed:(Feed *)feed bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sendLocation = FALSE;
        myFeed = feed;
        feedUpdater = [[UpdateFeed alloc] initWithFeed:myFeed];
        feedLoader = [[LoadFeed alloc] initWithFeed:myFeed];
        self.title = NSLocalizedString(@"Tally", @"Tally");
        self.tabBarItem.image = [UIImage imageNamed:@"78-stopwatch"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentTally) name:@"currentValueUpdated" object:nil];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (IBAction)updateCurrentTally
{
    [currentTallyField setText:myFeed.currentValue];
}

- (IBAction)connectionError
{
    [currentTallyField setText:@"Connection failed"];    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    if(statusCode >= 400) {
        [connection cancel];
    }
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	currentTallyField.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if([responseString length] > 1) {
        NSDictionary *tallyDatastream = [responseString JSONValue];
        NSArray *newArray = [tallyDatastream objectForKey:@"datapoints"];
        NSMutableArray *currentDataPoints = [[NSMutableArray alloc] init];
        int i;
        for(i = 0; i < [newArray count]; i++) {
            [currentDataPoints addObject:[[newArray objectAtIndex:i] objectForKey:@"value"]];
        }
        [sparkline setLineColor:[UIColor colorWithRed:0.196078 green:0.309804 blue:0.521569 alpha:1]];
        [sparkline setLineWidth:1.0];
        [sparkline setData:currentDataPoints];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
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
//    NSLog(@"f:%@ a:%@", myFeed.feedId, myFeed.apiKey);
    if((myFeed.feedId == (id)[NSNull null] || myFeed.feedId.length == 0) || (myFeed.apiKey == (id)[NSNull null] || myFeed.apiKey.length == 0)) {
        currentTallyField.text = @"Please configure your feed";
        [plusOneButton setEnabled:FALSE];
        [minusOneButton setEnabled:FALSE];
        [self beginAuthorisation];
    } else {
        [locationManager startUpdatingLocation];
        [plusOneButton setEnabled:TRUE];
        [minusOneButton setEnabled:TRUE];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/feeds/%@/datastreams/tally.json?key=%@", kPBapiEndpoint, myFeed.feedId, myFeed.apiKey];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1.0];
        [[NSURLConnection alloc] initWithRequest:request delegate:feedLoader];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [locationManager stopMonitoringSignificantLocationChanges];
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

- (IBAction)plusOne:(id)sender {
    NSString *val = [[NSString alloc] initWithFormat:@"%d", [myFeed.currentValue intValue] + 1];
    currentTallyField.text = val;
    [myFeed setCurrentValue:val];
    [self updateFeed:myFeed.currentValue];
}

- (IBAction)minusOne:(id)sender {
    NSString *val = [[NSString alloc] initWithFormat:@"%d", [myFeed.currentValue intValue] - 1];
    currentTallyField.text = val;
    [myFeed setCurrentValue:val];
    [self updateFeed:myFeed.currentValue];
}

-(void)updateFeed:(NSString *)currentValue {
    NSString *postBody;
    if(sendLocation) {
        postBody = [[NSString alloc] initWithFormat:@"{\"version\":\"1.0.0\",\"tags\":[\"tally\",\"counter\"],\"location\":{\"lat\":\"%@\",\"lon\":\"%@\"},\"datastreams\":[{\"id\":\"tally\",\"current_value\":\"%@\"},{\"id\":\"lat\",\"current_value\":\"%@\"},{\"id\":\"lon\",\"current_value\":\"%@\"}]}", currentLat, currentLon, currentValue, currentLat, currentLon];
    } else {
        postBody = [[NSString alloc] initWithFormat:@"{\"version\":\"1.0.0\",\"tags\":[\"tally\",\"counter\"],\"datastreams\":[{\"id\":\"tally\",\"current_value\":\"%@\"}]}", currentValue];
    }
    NSString *url = [[NSString alloc] initWithFormat:@"%@/feeds/%@.json?key=%@", kPBapiEndpoint, myFeed.feedId, myFeed.apiKey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:feedUpdater];
    
    [self drawSparkLine];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    sendLocation = TRUE;
    currentLat = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.latitude];
    currentLon = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    sendLocation = FALSE;    
}

- (void)drawSparkLine {
    NSString *graphUrl = [[NSString alloc] initWithFormat:@"%@/feeds/%@/datastreams/tally.json?duration=1hour&interval_type=discrete&interval=15&key=%@", kPBapiEndpoint, myFeed.feedId, myFeed.apiKey];
    responseData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:graphUrl]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)beginAuthorisation {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pachube login"
                                                    message:@"You need to login to Pachube to continue"
                                                   delegate:self
                                          cancelButtonTitle:@"No thanks"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"OK"])
    {
        OAuthRequestController *oauthController = [[OAuthRequestController alloc] initWithFeed:myFeed];
        [self presentModalViewController:oauthController animated:YES];
    }
}

@end

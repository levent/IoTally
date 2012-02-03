//
//  FirstViewController.m
//  IoTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TallyViewController.h"

@implementation TallyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sendLocation = FALSE;
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
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
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
        currentTallyField.text = [tallyDatastream objectForKey:@"current_value"];
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
    feedId = [[NSUserDefaults standardUserDefaults] objectForKey:@"feedId"];
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{   
    NSString *url = [[NSString alloc] initWithFormat:@"http://api.pachube.com/v2/feeds/%@/datastreams/tally.json?key=%@", feedId, apiKey];
	responseData = [NSMutableData data];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1.0];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

    [super viewDidAppear:animated];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d", row];
}

- (IBAction)plusOne:(id)sender {
    currentTallyField.text = [[NSString alloc] initWithFormat:@"%d", [currentTallyField.text intValue] + 1];
    [self updateFeed:currentTallyField.text];
}

- (IBAction)minusOne:(id)sender {
    currentTallyField.text = [[NSString alloc] initWithFormat:@"%d", [currentTallyField.text intValue] - 1];
    [self updateFeed:currentTallyField.text];
}

-(void)updateFeed:(NSString *)currentValue {
    NSString *postBody;
    if(sendLocation) {
        postBody = [[NSString alloc] initWithFormat:@"{\"version\":\"1.0.0\",\"location\":{\"lat\":\"%@\",\"lon\":\"%@\"},\"datastreams\":[{\"id\":\"tally\",\"current_value\":\"%@\"},{\"id\":\"lat\",\"current_value\":\"%@\"},{\"id\":\"lon\",\"current_value\":\"%@\"}]}", currentLat, currentLon, currentValue, currentLat, currentLon];
    } else {
        postBody = [[NSString alloc] initWithFormat:@"{\"version\":\"1.0.0\",\"datastreams\":[{\"id\":\"tally\",\"current_value\":\"%@\"}]}", currentValue];
    }
    NSString *url = [[NSString alloc] initWithFormat:@"http://api.pachube.com/v2/feeds/%@.json?key=%@", feedId, apiKey]; 
    responseData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
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
    NSString *graphUrl = [[NSString alloc] initWithFormat:@"http://api.pachube.com/v2/feeds/%@/datastreams/tally.csv?duration=1hour&interval_type=discrete&interval=15&key=%@", feedId, apiKey];
    NSString *receivedDataPoints = [NSString stringWithContentsOfURL:[NSURL URLWithString:graphUrl]];
    NSArray *newArray = [receivedDataPoints componentsSeparatedByString:@"\n"];
    NSMutableArray *currentDataPoints = [[NSMutableArray alloc] init];
    int i;
    for(i = 0; i < [newArray count]; i++) {
        [currentDataPoints addObject:[[[newArray objectAtIndex:i] componentsSeparatedByString:@","] objectAtIndex:1]];
    }
    
    [sparkline setLineColor:[UIColor colorWithRed:0.196078 green:0.309804 blue:0.521569 alpha:1]];
    [sparkline setLineWidth:1.0];
    [sparkline setData:currentDataPoints];
}

@end

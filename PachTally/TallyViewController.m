//
//  FirstViewController.m
//  PachTally
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
    NSLog(responseString);
    if([responseString length] > 1) {
        NSDictionary *tallyDatastream = [responseString JSONValue];
        NSLog(@"Dictionary value for \"current value\" is \"%@\"", [tallyDatastream objectForKey:@"current_value"]);
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

    NSString *url = [[NSString alloc] initWithFormat:@"http://api.pachube.com/v2/feeds/%@/datastreams/tally.csv?key=%@", feedId, apiKey]; 
    responseData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    NSString *postString = [currentTallyField text];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)minusOne:(id)sender {
    
    currentTallyField.text = [[NSString alloc] initWithFormat:@"%d", [currentTallyField.text intValue] - 1];
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://api.pachube.com/v2/feeds/%@/datastreams/tally.csv?key=%@", feedId, apiKey]; 
    responseData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    NSString *postString = [currentTallyField text];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end

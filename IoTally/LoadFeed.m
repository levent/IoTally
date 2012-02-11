//
//  LoadFeed.m
//  IoTally
//
//  Created by Levent Ali on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadFeed.h"

@implementation LoadFeed

- (id)initWithFeed:(Feed *)feed
{
    myFeed = feed;
    responseData = [NSMutableData data];
    return self;
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
	myLabel.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Fdsfsdfas");
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(responseString);
    if([responseString length] > 1) {
        NSDictionary *tallyDatastream = [responseString JSONValue];
        [myFeed setCurrentValue:[tallyDatastream objectForKey:@"current_value"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentValueUpdated" object:nil];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}
@end

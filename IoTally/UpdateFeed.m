//
//  UpdateFeed.m
//  IoTally
//
//  Created by Levent Ali on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdateFeed.h"

@implementation UpdateFeed

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
//	myLabel.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionError" object:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"FDSASD");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

@end

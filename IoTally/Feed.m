//
//  Feed.m
//  IoTally
//
//  Created by Levent Ali on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Feed.h"

@implementation Feed

@synthesize currentValue;
@synthesize feedId;
@synthesize apiKey;

- (id)initWithUserDefaults
{
    feedId = [[NSUserDefaults standardUserDefaults] objectForKey:@"feedId"];
    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    return self;
}

- (void)saveFeedId:(NSString *)value
{
    feedId = value;
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"feedID"];
}

@end

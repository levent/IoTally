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

- (id)initWithUserDefaults
{
    feedId = [[NSUserDefaults standardUserDefaults] objectForKey:@"feedId"];
//    apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
    return self;
}

@end

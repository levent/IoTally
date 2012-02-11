//
//  LoadFeed.h
//  IoTally
//
//  Created by Levent Ali on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "Feed.h"

@interface LoadFeed : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *responseData;
    Feed *myFeed;
    IBOutlet UILabel *myLabel;
}
- (id)initWithFeed:(Feed *)feed;

@end

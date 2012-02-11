//
//  UpdateFeed.h
//  IoTally
//
//  Created by Levent Ali on 11/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "Feed.h"

@interface UpdateFeed : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *responseData;
    Feed *myFeed;
    UILabel *myLabel;
}
- (id)initWithFeedAndLabel:(Feed *)feed label:(UILabel *)label;
@end

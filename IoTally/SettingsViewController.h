//
//  SecondViewController.h
//  IoTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDelegate.h"
#import "Feed.h"
#import <QuartzCore/QuartzCore.h>
#import "ButtonWithColor.h"

@interface SettingsViewController : UIViewController <FeedDelegate> {
//    NSString *feedId;
//    NSString *apiKey;
    Feed *myFeed;
    
    IBOutlet UITextField *feedIdField;
    IBOutlet UITextField *apiKeyField;
    IBOutlet ButtonWithColor *resetTally;
}
@property (nonatomic, retain) NSString *accessToken;

- (IBAction)saveSettings:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)setTallyToZero:(id)sender;

- (void)beginAuthorisation;
- (void)loadSettings;
@end

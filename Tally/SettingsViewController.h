//
//  SecondViewController.h
//  Tally
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
    Feed *myFeed;
    
    IBOutlet UILabel *feedIdField;
    IBOutlet UILabel *infoField;
    IBOutlet ButtonWithColor *resetTally;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *loginButton;
}
@property (nonatomic, retain) NSString *accessToken;

- (IBAction)saveSettings:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)setTallyToZero:(id)sender;
- (IBAction)beginAuthorisation:(id)sender;

- (void)loadSettings;
@end

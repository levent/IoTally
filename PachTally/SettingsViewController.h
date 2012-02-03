//
//  SecondViewController.h
//  PachTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ButtonWithColor.h"

@interface SettingsViewController : UIViewController {
    NSString *feedId;
    NSString *apiKey;
    
    IBOutlet UITextField *feedIdField;
    IBOutlet UITextField *apiKeyField;
    IBOutlet ButtonWithColor *resetTally;
}

-(IBAction)saveSettings:(id)sender;
-(IBAction)backgroundClick:(id)sender;
-(IBAction)setTallyToZero:(id)sender;
@end

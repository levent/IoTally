//
//  FirstViewController.h
//  IoTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDelegate.h"
#import "UpdateFeed.h"
#import "LoadFeed.h"
#import "Feed.h"
#import "SBJson.h"
#import "CKSparkline.h"

@interface TallyViewController : UIViewController <CLLocationManagerDelegate, FeedDelegate> {
    NSString *currentLat;
    NSString *currentLon;
    Feed *myFeed;
    
    UpdateFeed *feedUpdater;
    LoadFeed *feedLoader;
    
    BOOL *sendLocation;
    
    CLLocationManager *locationManager;
    
    NSMutableData *responseData;
    
    IBOutlet CKSparkline *sparkline;
    
    IBOutlet UIButton *plusOneButton;
    IBOutlet UIButton *minusOneButton;
//    IBOutlet UILabel *currentTallyField;
}

@property (nonatomic, retain) IBOutlet UILabel *currentTallyField;

-(IBAction)updateCurrentTally;
-(IBAction)connectionError;

-(IBAction)plusOne:(id)sender;
-(IBAction)minusOne:(id)sender;
//-(void)locationUpdate:(CLLocation *)location;
-(void)drawSparkLine;
-(void)updateFeed:(NSString *)currentValue;

@end

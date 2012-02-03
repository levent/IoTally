//
//  FirstViewController.h
//  IoTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "CKSparkline.h"

@interface TallyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate> {
    NSString *feedId;
    NSString *apiKey;
    NSString *currentLat;
    NSString *currentLon;
    
    BOOL *sendLocation;
    
    CLLocationManager *locationManager;
    
    NSMutableData *responseData;
    
    IBOutlet CKSparkline *sparkline;
    
    IBOutlet UIButton *plusOneButton;
    IBOutlet UIButton *minusOneButton;
    IBOutlet UILabel *currentTallyField;
}

-(IBAction)plusOne:(id)sender;
-(IBAction)minusOne:(id)sender;
//-(void)locationUpdate:(CLLocation *)location;
-(void)drawSparkLine;
-(void)updateFeed:(NSString *)currentValue;

@end

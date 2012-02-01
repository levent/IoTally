//
//  FirstViewController.h
//  PachTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@interface TallyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate> {
    NSString *feedId;
    NSString *apiKey;
    NSString *currentLat;
    NSString *currentLon; 
    
    CLLocationManager *locationManager;
    
    NSMutableData *responseData;
    
    IBOutlet UIButton *plusOneButton;
    IBOutlet UILabel *currentTallyField;
}

-(IBAction)plusOne:(id)sender;
-(IBAction)minusOne:(id)sender;
//-(void)locationUpdate:(CLLocation *)location;

@end

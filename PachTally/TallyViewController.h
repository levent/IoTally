//
//  FirstViewController.h
//  PachTally
//
//  Created by Levent Ali on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@interface TallyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSString *feedId;
    NSString *apiKey;
    
    NSMutableData *responseData;
    
    IBOutlet UILabel *currentTallyField;
}

-(IBAction)plusOne:(id)sender;
-(IBAction)minusOne:(id)sender;

@end

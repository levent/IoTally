//
//  ButtonWithColor.h
//  IoTally
//
//  Created by Levent Ali on 03/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ButtonWithColor : UIButton {
//    UIColor *_highColor;
//    UIColor *_lowColor;
    
    CAGradientLayer *gradientLayer;
}

@property (unsafe_unretained) UIColor *_highColor;
@property (unsafe_unretained) UIColor *_lowColor;
@property (nonatomic, retain) CAGradientLayer *gradientLayer;

- (void)setHighColor:(UIColor*)color;
- (void)setLowColor:(UIColor*)color;

@end

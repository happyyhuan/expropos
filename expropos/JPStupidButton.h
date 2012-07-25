//
//  JPStupidButton.h
//  expropos
//
//  Created by haitao chen on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ButtonClick;


@interface JPStupidButton : UIButton {
    int              buttonMode;
    int              state;
    CALayer         *baseLayer;
    CAGradientLayer *gradient;
    CGRect           orig_bounds;
    BOOL             flag;
}
@property id<ButtonClick> buttonClickDelegate;

- (void)setMode:(int) mode;

extern int const JPStupidButtonPopMode;
extern int const JPStupidButtonStickMode;

- (void)animateUp;
@end

@protocol ButtonClick <NSObject>

-(void)touch:(id)sender;

@end
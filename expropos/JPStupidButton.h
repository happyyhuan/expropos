//
//  JPStupidButton.h
//  AnimationPlay
//
//  Created by James Pozdena on 5/9/11.
//  Copyright 2011 James Pozdena. All rights reserved.
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
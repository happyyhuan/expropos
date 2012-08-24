//
//  MyButton.m
//  loginView
//
//  Created by haitao chen on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyButton
@synthesize image = _image;
@synthesize name = _name;
@synthesize bgImage =_bgImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    [_image drawInRect:CGRectMake(0.0f,
                                  0.0f,
                                  self.frame.size.width,
                                   self.frame.size.height*0.7)];
    
    [_bgImage drawInRect:CGRectMake(0.0f,
                                  0.0f,
                                  self.frame.size.width,
                                  self.frame.size.height*0.7)];

    
    UIFont *helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]; 
    if (self.name.length == 1)
    {
        [_name drawAtPoint:CGPointMake(self.frame.size.width*0.3, self.frame.size.height*0.8) withFont:helveticaBold];

    }
    else if (self.name.length == 2)
    {
         [_name drawAtPoint:CGPointMake(self.frame.size.width*0.2, self.frame.size.height*0.8) withFont:helveticaBold];
    }
    else if (self.name.length == 3)
    {
         [_name drawAtPoint:CGPointMake(self.frame.size.width*0.1, self.frame.size.height*0.8) withFont:helveticaBold];
    }
    else if (self.name.length > 3)
    {
        [_name drawAtPoint:CGPointMake(self.frame.size.width*0.01, self.frame.size.height*0.8) withFont:helveticaBold];
    }
}

@end

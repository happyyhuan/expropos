//
//  exproposMyScrollView.m
//  expropos
//
//  Created by haitao chen on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposMyScrollView.h"

@implementation exproposMyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if([view isKindOfClass:[UIButton class]]){
        return YES;
    }
     return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}
@end

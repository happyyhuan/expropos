//
//  exproposValidater.h
//  expropos
//
//  Created by chen on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproRestDelegate.h"
#import "exproposMemberRegisterController.h"

@interface exproposValidater : ExproRestDelegate

@property (strong, nonatomic) exproposMemberRegisterController  *registerController;
-(void)validate:(NSString *)telText;

@end

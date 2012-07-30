//
//  exproposMemberShowInfoViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMember.h"


@interface exproposMemberShowInfoViewController : UITableViewController
@property (strong,nonatomic) ExproMember *member;
@property (strong,nonatomic) UIButton *button;
@end

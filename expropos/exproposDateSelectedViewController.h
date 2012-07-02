//
//  exproposDateSelectedViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exproposDateSelectedViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong,nonatomic) UIViewController *viewController;
@property (nonatomic) BOOL isBegin;
@end

//
//  exproposDateSelectedViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exproposDateSelectedViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;//时间选择器
@property (strong,nonatomic) UIViewController *viewController;
@property (nonatomic) BOOL isBegin;//用于判断为开始时间还是截止时间付值
@end

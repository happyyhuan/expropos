//
//  exproposMainViewController.h
//  expropos
//
//  Created by gbo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Restkit/Restkit.h>

@interface exproposMainViewController : UIViewController <UISplitViewControllerDelegate,RKRequestDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;
@property (strong, nonatomic) IBOutlet UIToolbar *menuTool;

- (IBAction)logout:(UIBarButtonItem *)sender;


@end

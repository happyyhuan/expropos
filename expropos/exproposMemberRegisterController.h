//
//  exproposMemberRegisterController.h
//  expropos
//
//  Created by chen on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exproposMemberRegisterController : UITableViewController<UITextFieldDelegate>

{
   
//    UITextField *telField;
//    UITextField *firstNameField;
//    UITextField *lastNameField;
//    UITextField *birthField;
//    
//    NSString *firstName;
//    NSString *lastName;
//    NSString *birth;
//    NSString *telphone;
}
@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic, retain) NSString *telphone;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,retain) NSDate *birth;
@property (nonatomic,strong) NSMutableArray *levelItem;
@end

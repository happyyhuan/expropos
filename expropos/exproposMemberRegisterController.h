//
//  exproposMemberRegisterController.h
//  expropos
//
//  Created by chen on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMainViewController.h"
#define kKeyboardAnimationDuration (0.35f)
@interface exproposMemberRegisterController : UITableViewController<UITextFieldDelegate>

{

}
@property (strong,nonatomic )exproposMainViewController *mainViewController;
@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *telphone;

@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSString *petName;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSDate *birth;
@property (nonatomic,strong) NSMutableArray *levelItem;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic) BOOL account;
@property (nonatomic,strong) NSString *status;

@property (nonatomic,strong) NSString *memPetName;
@property (nonatomic,strong) NSString *savings;
@property (nonatomic,strong) NSDate *createTime;
@property (nonatomic,strong) NSDate *dueTime;
@property (nonatomic,strong) NSMutableArray *privacyItem;
@property (nonatomic,strong) NSString *point;
@property (nonatomic,strong) NSString *dateSel;

@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;

@property (nonatomic, retain) UITextField *activeTextField;// 当前活动的UITextField

// minMoveUpY = (UITextField在最初位置时的y) + (UITextField的height) - (键盘出现后的y)，其中的坐标是控件在window上的坐标
@property (nonatomic, assign) CGFloat minMoveUpDeltaY;// 最少上移的像素

@property (nonatomic, assign) CGRect keyboardFrame;// 键盘显示出来时的矩形框

@property (nonatomic, assign) BOOL isSwitchedTextField;// 是不是已经从一个输入框切换到另一个输入框

@property (nonatomic, assign) BOOL canUserSeeKeyboard;// 用户是否可以看到键盘

- (void)handleTap;

// 用于判断键盘是否遮住了UITextField，这里的遮住包括完全遮住及部分遮住
// 判断是否遮住的条件：如果(UITextField在最初位置时的y) + (UITextField的height) - (键盘出现后的y) > 0，就表示遮住
// 也即minMoveUpY > 0时，表示遮住
- (BOOL)isKeyboardHideTextField:(UITextField *)textField;

// 用于注册键盘通知，可以从通知中获取键盘的矩形框
- (void)registerKeyboardNotifications;

- (void)handleKeyboardDidHide:(NSNotification *)notification;
- (void)handleKeyboardDidShow:(NSNotification *)notification;

- (void)setKeyboardFrameByNSNotification:(NSNotification *)notification;

- (void)moveUp;
- (void)moveDown;

@end

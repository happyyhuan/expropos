//
//  exproposViewController.h
//  expropos
//
//  Created by gbo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMainViewController.h"
#define kKeyboardAnimationDuration (0.30f)

@interface exproposViewController : UIViewController <UITextFieldDelegate>
{
    NSString *username;
    NSString *password;
    NSString *orgId;
    UIView *refreshHeaderView;
    exproposMainViewController *mainViewController;
}


@property (strong, nonatomic) IBOutlet UILabel *orglabel;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (nonatomic,strong)UIManagedDocument *exprodatabase;
@property (nonatomic,strong) IBOutlet UIView *loginview;
@property (nonatomic,strong) NSArray *users;

@property (strong, nonatomic) IBOutlet UILabel *phonelable;
@property (strong, nonatomic) IBOutlet UIButton *selUserButton;


@property (strong,nonatomic) IBOutlet UIView *usersView;
@property (strong,nonatomic) NSMutableArray *userArray;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;


@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;

@property (nonatomic, retain) UITextField *activeTextField;// 当前活动的UITextField

// minMoveUpY = (UITextField在最初位置时的y) + (UITextField的height) - (键盘出现后的y)，其中的坐标是控件在window上的坐标
@property (nonatomic, assign) CGFloat minMoveUpDeltaY;// 最少上移的像素

@property (nonatomic, assign) CGRect keyboardFrame;// 键盘显示出来时的矩形框

@property (nonatomic, assign) BOOL isSwitchedTextField;// 是不是已经从一个输入框切换到另一个输入框

@property (nonatomic, assign) BOOL canUserSeeKeyboard;// 用户是否可以看到键盘

//@property (nonatomic, assign) BOOL isMove;// 是否已经上移

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

-(IBAction)touchout:(id)sender;

@end

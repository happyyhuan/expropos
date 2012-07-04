//
//  exproposViewController.h
//  expropos
//
//  Created by gbo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMainViewController.h"

@interface exproposViewController : UIViewController <UITextFieldDelegate>
{
    NSString *username;
    NSString *password;
    UIView *refreshHeaderView;
    exproposMainViewController *mainViewController;
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (nonatomic,strong)UIManagedDocument *exprodatabase;
@property (nonatomic,strong) IBOutlet UIView *loginview;
@property (nonatomic,strong) NSArray *members;


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@end

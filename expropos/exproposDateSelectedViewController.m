//
//  exproposDateSelectedViewController.m
//  expropos
//
//  Created by haitao chen on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposDateSelectedViewController.h"
#import "exproposDealSelectedViewController.h"
#import "exproposMemberRegisterController.h"
#import "exproposAddMemberSavingListViewController.h"
#import "exproposAddMemberSavingViewController.h"

@interface exproposDateSelectedViewController ()

@end

@implementation exproposDateSelectedViewController
@synthesize datePicker = _datePicker;
@synthesize viewController = _viewController;
@synthesize isBegin = _isBegin;




-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.viewController isKindOfClass:[exproposMemberRegisterController class]])
    {
        exproposMemberRegisterController *dealSelect = (exproposMemberRegisterController *)self.viewController;
        if ([dealSelect.dateSel isEqualToString:@"birthTime"])
        {
            dealSelect.birth = self.datePicker.date;
        }
        else {
            dealSelect.dueTime = self.datePicker.date;
        }
        [dealSelect.tableView reloadData];
    }
    if( [self.viewController isKindOfClass:[exproposAddMemberSavingListViewController class]]){
         exproposAddMemberSavingListViewController *addMemberSavingList = (exproposAddMemberSavingListViewController *)self.viewController;
        if(self.isBegin){
            addMemberSavingList.beginTime = self.datePicker.date;
           
        }else {
            addMemberSavingList.endTime = self.datePicker.date;
           
        }
    }
    if( [self.viewController isKindOfClass:[exproposAddMemberSavingViewController class]]){
        exproposAddMemberSavingViewController *addMemberSaving = (exproposAddMemberSavingViewController *)self.viewController;
        addMemberSaving.member.savingDueTime = self.datePicker.date;
        [addMemberSaving.tableView reloadData];
    }
   if( [self.viewController isKindOfClass:[exproposDealSelectedViewController class]])
    {
        exproposDealSelectedViewController *dealSelect = (exproposDealSelectedViewController *)self.viewController;
        if(self.isBegin){
            dealSelect.beginDate = self.datePicker.date;
        
        }else {
        dealSelect.endDate = self.datePicker.date;
        
        }
        [dealSelect.tableView reloadData];
    }
    [super viewWillDisappear:animated];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDate *now = [NSDate date];
	[self.datePicker setDate:now animated:NO];
     self.contentSizeForViewInPopover = CGSizeMake(300, 210);
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  expropoStoreEditViewController.m
//  expropos
//
//  Created by chen on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "expropoStoreEditViewController.h"
#import "exproposStoreStateController.h"
#import "exproposStoreEdit.h"
#import "ExproMerchant.h"
#import "ExproWarehouse.h"
#import "exproposAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface expropoStoreEditViewController ()

@end

@implementation expropoStoreEditViewController
@synthesize confirmButton;
@synthesize cancelButton;
@synthesize toolView;
@synthesize tableView;
@synthesize editLabel;

@synthesize storeNo =_storeNo;
@synthesize storeNotice =_storeNotice;
@synthesize storeName = _stroeName;
@synthesize storeTransit=_storeTransit;
@synthesize storeAddress =_storeAddress;
@synthesize storeComment =_storeComment;
@synthesize storeState=_storeState;

@synthesize privacyItem=_privacyItem;
@synthesize popover=_popover;
@synthesize exproStore =_exproStore;
@synthesize storeView=_storeView; 
@synthesize exproStoreEdit=_exproStoreEdit;





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
    _privacyItem = [[NSMutableArray alloc] initWithCapacity:20];

    if (self.exproStore)
    {
        editLabel.text = @"编辑门店";
        self.storeNo = self.exproStore.inventarNum;
        self.storeName = self.exproStore.name;
        self.storeNotice = self.exproStore.notice;
        self.storeAddress = self.exproStore.address;
        self.storeComment = self.exproStore.comment;
        NSLog(@"state==%i",self.exproStore.state.intValue);
        [self.privacyItem addObject:self.exproStore.state];
    }
    else {
        editLabel.text = @"添加门店";
        self.storeName = nil;
        self.storeNotice = nil;
        self.storeAddress = nil;
        self.storeComment = nil;
    }
    	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setExproStore:nil];
    [self setConfirmButton:nil];
    [self setCancelButton:nil];
    [self setToolView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5)
    {
        return 70.0;
    }
    else {
        return 40.0;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 2)
    {
        self.storeNotice = textView.text;
    }
    else if(textView.tag == 3)
        {
        self.storeAddress = textView.text;
        }
    
    else if(textView.tag == 4)
        {
            self.storeTransit = textView.text;

        }
    
    else if(textView.tag == 5)
        {
            self.storeComment = textView.text;
        }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    if(indexPath.row == 0)
    {
        UITextField *storeNameField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 200, 25)];
        [cell addSubview:storeNameField];
        [storeNameField setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.text = NSLocalizedString(@"门店名称", nil);  
        [storeNameField setBackgroundColor:[UIColor whiteColor]];
        storeNameField.borderStyle = UITextBorderStyleRoundedRect;
        storeNameField.textAlignment = UITextAlignmentLeft;
        storeNameField.text = self.storeName;
        storeNameField.tag = 1;
        storeNameField.delegate = self;
        storeNameField.keyboardType = UIKeyboardTypeDefault;
        [storeNameField addTarget:self action:@selector(saveNameField:) forControlEvents:UIControlEventEditingChanged];
    }
    else if(indexPath.row == 1)
    {
        UITextField *storeNoField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 200, 25)];
        [cell addSubview:storeNoField];
        [storeNoField setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.text = NSLocalizedString(@"资产编号", nil);  
        [storeNoField setBackgroundColor:[UIColor whiteColor]];
        storeNoField.borderStyle = UITextBorderStyleRoundedRect;
        storeNoField.textAlignment = UITextAlignmentLeft;
        storeNoField.text = self.storeNo;
        storeNoField.tag = 1;
        storeNoField.delegate = self;
        storeNoField.keyboardType = UIKeyboardTypeNumberPad;
        [storeNoField addTarget:self action:@selector(saveStoreNoField:) forControlEvents:UIControlEventEditingChanged];
    }
    else if(indexPath.row == 2)
    {
        UITextView *storeNoticeField = [[UITextView alloc]initWithFrame:CGRectMake(100, 10, 400, 50)];
        [cell addSubview:storeNoticeField];
        [storeNoticeField setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.text = NSLocalizedString(@"门店公告", nil);  
        [storeNoticeField setBackgroundColor:[UIColor whiteColor]];
//        storeNoticeField.borderStyle = UITextBorderStyleRoundedRect;
        [storeNoticeField.layer setBorderColor: [[UIColor grayColor] CGColor]];      
        [storeNoticeField.layer setBorderWidth: 1.0];      
        [storeNoticeField.layer setCornerRadius:8.0f];      
        [storeNoticeField.layer setMasksToBounds:YES];
        [storeNoticeField setFont:[UIFont systemFontOfSize:17]];
        storeNoticeField.textAlignment = UITextAlignmentLeft;
        storeNoticeField.text = self.storeNotice;
        storeNoticeField.tag = 2;
        storeNoticeField.delegate = self;
        storeNoticeField.keyboardType = UIKeyboardTypeNumberPad;
//        [storeNoticeField addTarget:self action:@selector(saveNoticeField:) forControlEvents:UIControlEventEditingChanged];
    }
    else if(indexPath.row == 3)
    {
        UITextView *addressField = [[UITextView alloc]initWithFrame:CGRectMake(100, 10, 400, 50)];
        [cell addSubview:addressField];
        [addressField setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.text = NSLocalizedString(@"详细地址", nil);  
        [addressField setBackgroundColor:[UIColor whiteColor]];
        //addressField.borderStyle = UITextBorderStyleRoundedRect;
        [addressField.layer setBorderColor: [[UIColor grayColor] CGColor]];      
        [addressField.layer setBorderWidth: 1.0];      
        [addressField.layer setCornerRadius:8.0f];      
        [addressField.layer setMasksToBounds:YES];
        [addressField setFont:[UIFont systemFontOfSize:17]];
        addressField.textAlignment = UITextAlignmentLeft;
        addressField.text = self.storeAddress;
        addressField.tag = 3;
        addressField.delegate = self;
        addressField.keyboardType = UIKeyboardTypeNumberPad;
//        [addressField addTarget:self action:@selector(saveAddressField:) forControlEvents:UIControlEventEditingChanged];
    }
    else if(indexPath.row == 4)
    {
        UITextView *transitField = [[UITextView alloc]initWithFrame:CGRectMake(100, 10, 400, 50)];
        [cell addSubview:transitField];
        [transitField setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.text = NSLocalizedString(@"公交说明", nil);  
        [transitField setBackgroundColor:[UIColor whiteColor]];
        //transitField.borderStyle = UITextBorderStyleRoundedRect;
        [transitField.layer setBorderColor: [[UIColor grayColor] CGColor]];      
        [transitField.layer setBorderWidth: 1.0];      
        [transitField.layer setCornerRadius:8.0f];      
        [transitField.layer setMasksToBounds:YES];
        [transitField setFont:[UIFont systemFontOfSize:17]];
        transitField.textAlignment = UITextAlignmentLeft;
        transitField.text = self.storeTransit;
        transitField.tag = 4;
        transitField.delegate = self;
        transitField.keyboardType = UIKeyboardTypeNumberPad;
//        [transitField addTarget:self action:@selector(saveTransitField:) forControlEvents:UIControlEventEditingChanged];
    }
    else if(indexPath.row == 5)
    {
        UITextView *commentField = [[UITextView alloc]initWithFrame:CGRectMake(100, 10, 400, 50)];
        [cell addSubview:commentField];
        [commentField setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.text = NSLocalizedString(@"备注信息", nil);  
        [commentField setBackgroundColor:[UIColor whiteColor]];
        //commentField.borderStyle = UITextBorderStyleRoundedRect;
        
        [commentField.layer setBorderColor: [[UIColor grayColor] CGColor]];      
        [commentField.layer setBorderWidth: 1.0];      
        [commentField.layer setCornerRadius:8.0f];      
        [commentField.layer setMasksToBounds:YES];
        [commentField setFont:[UIFont systemFontOfSize:17]];
        commentField.textAlignment = UITextAlignmentLeft;
        commentField.text = self.storeComment;
        commentField.tag = 5;
        commentField.delegate = self;
        commentField.keyboardType = UIKeyboardTypeNumberPad;
//        [commentField addTarget:self action:@selector(saveCommentField:) forControlEvents:UIControlEventEditingChanged];
    }
    else if (indexPath.row == 6)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"门店状态";
        if(self.privacyItem.count == 0){
            cell.detailTextLabel.text= @"公开";
        }else {
            NSMutableString *message = [[NSMutableString alloc]init];
            NSArray *stateItemTitles = [NSArray arrayWithObjects:@"封闭",@"正常",@"公开",@"不公开", nil];
            for(NSNumber *i in self.privacyItem){
                [message appendFormat:@"%@,",[stateItemTitles objectAtIndex:i.intValue]];
            }
            cell.detailTextLabel.text = [message substringToIndex:(message.length-1)];
        }

    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6)
    {
        exproposStoreStateController *privacyItemSelect = [[exproposStoreStateController alloc]init];
        privacyItemSelect.viewController = self;
        if (_popover == nil) {
            _popover = [[UIPopoverController alloc] initWithContentViewController:privacyItemSelect];
        }else {
            _popover.contentViewController = privacyItemSelect;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
        [_popover presentPopoverFromRect:popoverRect
                              inView:cell //上面的矩形坐标是以这个view为参考的
            permittedArrowDirections:UIPopoverArrowDirectionRight //箭头方向
                            animated:YES];
    }
}

-(void)saveNameField:(UITextField *)field
{
    self.storeName = field.text;
}
-(void)saveStoreNoField:(UITextField *)field
{
    self.storeNo = field.text;
}

-(void)saveTransitField:(UITextField *)field
{
    self.storeTransit = field.text;
}
-(void)saveAddressField:(UITextField *)field
{
    self.storeAddress = field.text;
}
-(void)saveCommentField:(UITextField *)field
{
    self.storeComment = field.text;
}

-(void)saveNoticeField:(UITextField *)field
{
    self.storeNotice = field.text;
}

-(void)EditSucceed:(id)sender 
{
    ExproStore *newStore = (ExproStore *)sender;
    
    
    if (self.exproStore)      //更新本地门店信息
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                         message:@"门店信息修改成功" 
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
         
         [alert show]; 

         
         self.exproStore.name = self.storeName;
         self.exproStore.notice = self.storeNotice;
         self.exproStore.address = self.storeAddress;
         self.exproStore.comment = self.storeComment;
         self.exproStore.transitInfo = self.storeTransit;
         self.exproStore.lastModified = [NSDate new];
         self.exproStore.inventarNum = self.storeNo;    
         self.exproStore.state = [NSNumber numberWithInteger:self.storeState.intValue];
     }
     else {                    //新增门店信息
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                         message:@"门店信息添加成功" 
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
         
         [alert show]; 
                 newStore.name = self.storeName;
                 newStore.notice = self.storeNotice;
                 newStore.address = self.storeAddress;
                 newStore.comment = self.storeComment;
                 newStore.transitInfo = self.storeTransit;
                 newStore.lastModified = [NSDate new];
               
         newStore.inventarNum = self.storeNo; 
         
         exproposAppDelegate *appDelegate = (exproposAppDelegate *)[[UIApplication sharedApplication]delegate];
         NSString *orgId = appDelegate.currentOrgid ;
         NSFetchRequest *request = [ExproMerchant fetchRequest];
         NSPredicate *predicate = nil;
         NSMutableString *str = [[NSMutableString alloc]initWithString:@"(gid=%@)" ];
         NSMutableArray *params = [[NSMutableArray alloc]initWithObjects:orgId, nil];
         predicate = [NSPredicate predicateWithFormat:str argumentArray:params];
         NSLog(@"%@",predicate);
         request.predicate = predicate;
         NSArray *merchants = [ExproMerchant objectsWithFetchRequest:request];
         
         NSLog(@"%i",merchants.count);
         for (int i =0;i<merchants.count;i++)
         {
             ExproMerchant *merchant = [merchants objectAtIndex:i];  
             newStore.merchant = merchant;
         }        
     }    
    [[RKObjectManager sharedManager].objectStore save:nil];
    [self.storeView dismissModalViewControllerAnimated:YES];
    [self.storeView viewDidLoad];
    [self.storeView.storesTabelView reloadData];
}

- (IBAction)confirm:(id)sender {
   
    if (self.storeName && [self.storeName length]) {
        self.exproStoreEdit = [[exproposStoreEdit alloc]init];
        _exproStoreEdit.reserver = self;
        _exproStoreEdit.succeedCallBack = @selector(EditSucceed:);
        _exproStoreEdit.failedCallBack = @selector(EditFailed:);
        
        exproposAppDelegate *appDelegate =[[UIApplication sharedApplication]delegate];
        NSString *orgId = appDelegate.currentOrgid ;
        
        if (self.exproStore)
        {
            [self.exproStoreEdit storeEdit:self.storeName merchant:orgId  state:self.storeState inventar:self.storeNo district:@"ccc" address:self.storeAddress transit:self.storeTransit map:@"bbb" notice:self.storeNotice comment:self.storeComment storeId:self.exproStore.gid];
        }
        else {
            [self.exproStoreEdit storeAdd:self.storeName merchant:orgId  state:self.storeState inventar:self.storeNo district:@"ccc" address:self.storeAddress transit:self.storeTransit map:@"bbb" notice:self.storeNotice comment:self.storeComment]; 
        }
         
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                        message:NSLocalizedString(@"请输入门店信息", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
}

- (IBAction)cancel:(id)sender {
    [self.storeView dismissModalViewControllerAnimated:YES];
}
@end

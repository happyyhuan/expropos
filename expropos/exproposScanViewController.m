//
//  BarCodeScannerViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposScanViewController.h"
#import "ScannerOverlayView.h"
#import "exproposAppDelegate.h"
#import "ExproGoods.h"
#import "ExproMember.h"
#import "ExproUser.h"
#import "ExproMerchant.h"


@implementation exproposScanViewController
@synthesize showDeal = _showDeal;
@synthesize merchant = _merchant;
@synthesize barReaderViewController;

- (void)viewDidLoad{
	[super viewDidLoad];
	
    
	[self initBarReaderViewController];
	[self initAudio];

	//set frame
	UIView *barReaderView = [barReaderViewController view];
    barReaderView.frame = CGRectMake(360+3 ,118, 350 ,562);
	
	//add overlay for barReaderView
	ScannerOverlayView *overlay = [[ScannerOverlayView alloc] initWithFrame:[barReaderView bounds]];
	[barReaderViewController setCameraOverlayView:overlay];
	
	
	[[self view] addSubview:barReaderView];
	//[barReaderViewController.readerView start];//start scanning
    
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
  
    NSArray *members = [ExproMember findAll];
    for(ExproMember *member in members){
        if(member.user.gid == appDelegate.currentUser.gid){
            _merchant = member.org;
        }
    }
  
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}



-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGAffineTransform transform;
    CGRect frame = CGRectMake(0 ,0,351  ,562);
    switch (orientation) {
       
        case UIDeviceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(-90*M_PI/180);
            break;
        case UIDeviceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(90.0*M_PI/180);
                        break;
        default:
            transform = CGAffineTransformIdentity;
            break;
    }
     barReaderViewController.readerView.transform = transform;
    barReaderViewController.readerView.frame =frame;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [super viewDidAppear:animated];
    UISwipeGestureRecognizer *recognizer;    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];    
    [barReaderViewController.view addGestureRecognizer:recognizer]; 
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGAffineTransform transform;
    CGRect frame = CGRectMake(0 ,0,351  ,562);
    switch (orientation) {
        case UIDeviceOrientationFaceUp:
            transform = CGAffineTransformMakeRotation(-90*M_PI/180);
            
            break;
        case UIDeviceOrientationPortrait:
            transform = CGAffineTransformMakeRotation(-90*M_PI/180);
            
            break;

        case UIDeviceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(-90*M_PI/180);
            
            break;

        case UIDeviceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(-90*M_PI/180);
            
            break;
        case UIDeviceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(90.0*M_PI/180);
            break;
        default:
            transform = CGAffineTransformIdentity;
            break;
    }
    barReaderViewController.readerView.transform = transform;
    barReaderViewController.readerView.frame = frame;
 
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [super viewWillDisappear:animated];
    for (UISwipeGestureRecognizer *recognizer in [[barReaderViewController view]  gestureRecognizers]) {  
        [[barReaderViewController view] removeGestureRecognizer:recognizer];  
    } 
     
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{ 
     UIView *superView = self.view.superview;
    UIView *mineView = [superView viewWithTag:1];
    NSLog(@"%@",superView);
   
    //开始动画 
    [UIView beginAnimations:nil context:nil];  
    //设定动画持续时间 
    [UIView setAnimationDuration:0.5]; 
    //动画的内容 
    CGRect frame = mineView.frame;
    CGRect frame2 = self.view.frame;
    frame.origin.x += 360; 
    frame2.origin.x += 360;
    [mineView setFrame:frame]; 
    [self.view setFrame:frame2];
    //动画结束 
    [UIView commitAnimations]; 
    [barReaderViewController.readerView stop];
}

- (void)viewDidUnload{
	[super viewDidUnload];
	
}




- (void)initBarReaderViewController{
	barReaderViewController = [ZBarReaderViewController new];
    [barReaderViewController setCameraDevice:UIImagePickerControllerCameraDeviceFront];
	[barReaderViewController setShowsZBarControls:NO];
	barReaderViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
	barReaderViewController.showsCameraControls = NO;
	barReaderViewController.readerDelegate = self;
	barReaderViewController.readerView.torchMode = 0;
    [barReaderViewController setCameraCaptureMode:UIImagePickerControllerCameraCaptureModeVideo];
	ZBarImageScanner *scanner = barReaderViewController.scanner;
	
	
	[scanner setSymbology: ZBAR_ISBN10
				   config: ZBAR_CFG_ENABLE
					   to: 1];
	[scanner setSymbology: ZBAR_ISBN13
				   config: ZBAR_CFG_ENABLE
					   to: 1];
	
	// disable rarely used i2/5 to improve performance
	[scanner setSymbology: ZBAR_I25
				   config: ZBAR_CFG_ENABLE
					   to: 0];
}

- (void)initAudio
{
    if(beep)
        return;
    NSError *error = nil;
    beep = [[AVAudioPlayer alloc]
			initWithContentsOfURL:
			[[NSBundle mainBundle]
			 URLForResource: @"scan"
			 withExtension: @"wav"]
			error: &error];
    if(!beep)
        NSLog(@"ERROR loading sound: %@: %@",
              [error localizedDescription],
              [error localizedFailureReason]);
    else {
        beep.volume = .5f;
        [beep prepareToPlay];
    }
}

- (void) playBeep
{
    if(!beep)
        [self initAudio];
    [beep play];
}


- (void)  imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{

	
    //UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
	
    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *sym = nil;
    for(sym in results)
        break;
    if(!sym){
        return;
    }
    [self performSelector: @selector(playBeep)
			   withObject: nil
			   afterDelay: 0.0];
    
	NSLog(@"%@",sym.data);
    NSString *code = sym.data;
    NSSet *set = _merchant.goods;
    ExproGoods *getGoods = nil;
    for(ExproGoods *goods in set){
        if([goods.code isEqualToString:code]){
            getGoods = goods;
            if([_showDeal.mySelectedGoods containsObject:goods]){
              NSNumber *num =  [_showDeal.goodsAndAmount objectForKey:goods.gid];
                [_showDeal.goodsAndAmount setObject:[NSNumber numberWithInt:num.intValue+1] forKey:goods.gid];
            }else{
                [_showDeal.mySelectedGoods insertObject:goods atIndex:0];
                 [_showDeal.goodsAndAmount setObject:[NSNumber numberWithInt:1] forKey:goods.gid];
            }
            [_showDeal reloadViews];
            break;
        }
    }
    if(getGoods==nil){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未能找到匹配数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
	[self performSelector: @selector(playBeep)
			   withObject: nil
			   afterDelay: 0.0];
	
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
	
}




@end

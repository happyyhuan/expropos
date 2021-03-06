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
    barReaderView.frame = CGRectMake(365+3 ,171, 350 ,509);
	
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
   
    //开始动画 
    [UIView beginAnimations:nil context:nil];  
    //设定动画持续时间 
    [UIView setAnimationDuration:0.5]; 
    //动画的内容 
    CGRect frame = mineView.frame;
    CGRect frame2 = self.view.frame;
    frame.origin.x += 360; 
    frame2.origin.x += 365;
    [mineView setFrame:frame]; 
    [self.view setFrame:frame2];
    //动画结束 
    [UIView commitAnimations]; 
    [barReaderViewController.readerView stop];
    _showDeal.goodsCode.text = @"";
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
	
   
     
     /** decoded symbol type. */
//    typedef enum zbar_symbol_type_e {
//        ZBAR_NONE        =      0,  /**< no symbol decoded */
//        ZBAR_PARTIAL     =      1,  /**< intermediate status */
//        ZBAR_EAN2        =      2,  /**< GS1 2-digit add-on */
//        ZBAR_EAN5        =      5,  /**< GS1 5-digit add-on */
//        ZBAR_EAN8        =      8,  /**< EAN-8 */
//        ZBAR_UPCE        =      9,  /**< UPC-E */
//        ZBAR_ISBN10      =     10,  /**< ISBN-10 (from EAN-13). @since 0.4 */
//        ZBAR_UPCA        =     12,  /**< UPC-A */
//        ZBAR_EAN13       =     13,  /**< EAN-13 */
//        ZBAR_ISBN13      =     14,  /**< ISBN-13 (from EAN-13). @since 0.4 */
//        ZBAR_COMPOSITE   =     15,  /**< EAN/UPC composite */
//        ZBAR_I25         =     25,  /**< Interleaved 2 of 5. @since 0.4 */
//        ZBAR_DATABAR     =     34,  /**< GS1 DataBar (RSS). @since 0.11 */
//        ZBAR_DATABAR_EXP =     35,  /**< GS1 DataBar Expanded. @since 0.11 */
//        ZBAR_CODE39      =     39,  /**< Code 39. @since 0.4 */
//        ZBAR_PDF417      =     57,  /**< PDF417. @since 0.6 */
//        ZBAR_QRCODE      =     64,  /**< QR Code. @since 0.10 */
//        ZBAR_CODE93      =     93,  /**< Code 93. @since 0.11 */
//        ZBAR_CODE128     =    128,  /**< Code 128 */
     
	[scanner setSymbology: ZBAR_ISBN10
				   config: ZBAR_CFG_ENABLE
					   to: 1];
	[scanner setSymbology: ZBAR_ISBN13
				   config: ZBAR_CFG_ENABLE
					   to: 1];
    [scanner setSymbology: ZBAR_UPCA
				   config: ZBAR_CFG_ENABLE
					   to: 1];
	[scanner setSymbology: ZBAR_UPCE
				   config: ZBAR_CFG_ENABLE
					   to: 1];
    
    [scanner setSymbology: ZBAR_EAN8
				   config: ZBAR_CFG_ENABLE
					   to: 1];
    
	[scanner setSymbology: ZBAR_EAN13
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
    _showDeal.goodsCode.text = code;
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

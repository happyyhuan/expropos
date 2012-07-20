//
//  BarCodeScannerViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBarSDK.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "exproposShowDealOperateViewController.h"
#import "ExproMerchant.h"

@interface exproposScanViewController : UIViewController<ZBarReaderDelegate> {
	ZBarReaderViewController *barReaderViewController;
	//扫描成功之后的声音
	AVAudioPlayer *beep;
	

}
@property (nonatomic,strong) exproposShowDealOperateViewController *showDeal;
@property (nonatomic,strong) ExproMerchant *merchant;
@property (nonatomic,strong) ZBarReaderViewController *barReaderViewController;
- (void)initBarReaderViewController;
- (void)initAudio;
- (void)playBeep;
@end

//
//  exproposRestkit.h
//  expropos
//
//  Created by gbo on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHost @"192.168.0.115"
//#define kHost @"127.0.0.1"
#define kPort @":10080"
#define kHostURL  @"http://"kHost""kPort
#define kWebServiceURL    kHostURL

@interface exproposRestkit : NSObject
+ (void) InitRestKit;
@end

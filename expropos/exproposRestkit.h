//
//  exproposRestkit.h
//  expropos
//
//  Created by gbo on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kHost @"42.121.19.191"


//#define kHost @"127.0.0.1"


#define kPort @":10080"
#define kHostURL  @"http://"kHost
#define kWebServiceURL    kHostURL

@interface exproposRestkit : NSObject
+ (void) InitRestKit;
@end

//
//  ScannerOverlayView.h
//  expropos
//
//  Created by haitao chen on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	VERTICAL = 0,
	HORIZONTAL
} OverlayOrientation;

@interface ScannerOverlayView : UIView {
	UIView *infoView;
	OverlayOrientation overlayOrientation;
}
- (void)configOverlayOrientation;
- (void)cameraRotate:(NSNotification *)notification ;
- (void)drawSquareIndicatorWithContext:(CGContextRef)context;

@end

//
//  GSTETextFieldCell.h
//  GSTE
//
//  Created by 昊 曹 on 12-2-3.
//  Copyright (c) 2012年 泛盈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSTETextFieldCell : UITableViewCell<UITextFieldDelegate> {
    UITextField *textField;
}
@property (nonatomic, retain) IBOutlet UITextField *textField;

@end

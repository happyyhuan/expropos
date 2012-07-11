//
//  GSTETextFieldCell.m
//  GSTE
//
//  Created by 昊 曹 on 12-2-3.
//  Copyright (c) 2012年 泛盈. All rights reserved.
//

#import "GSTETextFieldCell.h"

@implementation GSTETextFieldCell
@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect myRect = self.frame;
        CGFloat width = myRect.size.width*0.6;
        CGFloat height = myRect.size.height*0.8;
        CGFloat x = myRect.size.width*0.3;
        CGFloat y = myRect.size.height*0.1;
        UITextField *aTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width,height)];
        aTextField.borderStyle = UITextBorderStyleNone;
        aTextField.textAlignment = UITextAlignmentLeft;
        aTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        aTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        aTextField.clearButtonMode = UITextFieldViewModeAlways;
        aTextField.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
        aTextField.returnKeyType = UIReturnKeyDone;
        aTextField.delegate = self;
        [self addSubview:aTextField];
        
        self.textField = aTextField;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.textField = nil;
   
}

- (void)textFieldDidEndEditing:(UITextField *)aTextField {
    [aTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
    [aTextField resignFirstResponder];
    return YES;
}
@end

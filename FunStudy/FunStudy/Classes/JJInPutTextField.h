//
//  JJInPutTextField.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJInPutTextField : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *numberLabel;


+ (instancetype)inputTextFieldWithFrame:(CGRect) frame WithPlaceholder:(NSString *)placeholder numberString:(NSString *)numberString delegate:(id)delegate;
@end

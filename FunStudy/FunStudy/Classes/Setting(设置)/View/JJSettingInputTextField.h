//
//  JJSettingInputTextField.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJSettingInputTextField : UIView

+(JJSettingInputTextField *)settingInputTextFieldWithTypeString:(NSString *)string placeHolder:(NSString *)placeHolder;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *typeLabel;

@end

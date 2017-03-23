//
//  JJSettingInputTextField.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSettingInputTextField.h"

@interface JJSettingInputTextField ()



@end

@implementation JJSettingInputTextField

+(JJSettingInputTextField *)settingInputTextFieldWithTypeString:(NSString *)string placeHolder:(NSString *)placeHolder{
    JJSettingInputTextField *inputTextField = [[JJSettingInputTextField alloc]init];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.typeLabel = [[UILabel alloc]init];
    inputTextField.typeLabel.textColor = NORMAL_COLOR;
    inputTextField.typeLabel.text = string;
    inputTextField.typeLabel.textColor = NORMAL_COLOR;
    inputTextField.typeLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
    [inputTextField addSubview:inputTextField.typeLabel];
    [inputTextField.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(inputTextField);
        make.left.with.offset(5 * KWIDTH_IPHONE6_SCALE);
    }];
    inputTextField.textField = [[UITextField alloc]init];
    inputTextField.textField.placeholder = placeHolder;
    inputTextField.textField.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    [inputTextField addSubview:inputTextField.textField];
    [inputTextField.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(inputTextField);
        make.right.with.offset(-5 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(inputTextField.typeLabel.mas_right).with.offset(5 * KWIDTH_IPHONE6_SCALE);
    }];

    return inputTextField;
}


@end

//
//  JJInPutTextField.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJInPutTextField.h"

@interface JJInPutTextField()<UITextFieldDelegate>

@end

@implementation JJInPutTextField
+ (instancetype)inputTextFieldWithFrame:(CGRect) frame WithPlaceholder:(NSString *)placeholder numberString:(NSString *)numberString delegate:(id)delegate {
    JJInPutTextField *inputTextField = [[JJInPutTextField alloc]initWithFrame:frame];
    inputTextField.textField.delegate = delegate;
    inputTextField.textField.placeholder = placeholder;
    inputTextField.numberLabel.text = numberString;
    return inputTextField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        DebugLog(@"%@",NSStringFromCGRect(frame));
//        self.backgroundColor = [UIColor greenColor];
        self.textField = [[UITextField alloc]init];
        self.textField.font = [UIFont boldSystemFontOfSize:17 *KWIDTH_IPHONE6_SCALE];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textField];
        [self.textField createBordersWithColor:RGBA(0, 155, 247, 1) withCornerRadius:10*KWIDTH_IPHONE6_SCALE andWidth:2 * KWIDTH_IPHONE6_SCALE];
        UIView *leftView = [[UIView alloc]init];
        leftView.width = (80.0 / 151) * frame.size.height;
        self.textField.leftView = leftView;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(112.0 / 151 * frame.size.height));
            make.width.equalTo(@(frame.size.width - frame.size.height / 2));
            make.right.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star"]];
//        imageView.backgroundColor = [UIColor purpleColor];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(self.mas_height);
        }];
        
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.font = [UIFont systemFontOfSize:9*KWIDTH_IPHONE6_SCALE];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(imageView);
        }];
        
    }
    return self;
}

@end

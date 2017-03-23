//
//  JKCountDownButton.h
//  JKCountDownButton
//
//  Created by Jakey on 15/3/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKCountDownButton;
typedef NSString* (^CountDownChanging)(JKCountDownButton *countDownButton,NSUInteger second);
typedef NSString* (^CountDownFinished)(JKCountDownButton *countDownButton,NSUInteger second);

typedef void (^TouchedCountDownButtonHandler)(JKCountDownButton *countDownButton,NSInteger tag);

@interface JKCountDownButton : UIButton
{
    NSInteger _second;
    NSUInteger _totalSecond;
    
    NSTimer *_timer;
    NSDate *_startDate;
    
    CountDownChanging _countDownChanging;
    CountDownFinished _countDownFinished;
    TouchedCountDownButtonHandler _touchedCountDownButtonHandler;
}
@property(nonatomic,strong) id userInfo;

-(void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
-(void)countDownChanging:(CountDownChanging)countDownChanging;
-(void)countDownFinished:(CountDownFinished)countDownFinished;

-(void)startCountDownWithSecond:(NSUInteger)second;
-(void)stopCountDown;
@end



//用法
/*
//验证码按钮
- (JKCountDownButton *)countDownBtn {
    if(!_countDownBtn) {
        _countDownBtn = [[JKCountDownButton alloc]init];
        [self.view addSubview:_countDownBtn];
        [_countDownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countDownBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        //    _countDownBtn.backgroundColor = [UIColor greenColor];
        [_countDownBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
        _countDownBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_countDownBtn countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
            if (!self.phoneTextField.textField.text.length) {
                [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入手机号" hudMode:MBProgressHUDModeText];
                return;
            }else if (![Util isMobileNumber:self.phoneTextField.textField.text]) {
                [MBProgressHUD showHUDWithDuration:1.0 information:@"请输入正确的手机号" hudMode:MBProgressHUDModeText];
                return;
            }
            sender.enabled = NO;
            [self.codeTextField.textField becomeFirstResponder];
            [sender startCountDownWithSecond:60];
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"点击重新获取";
            }];
        }];
        [_countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTextField.mas_bottom);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.codeTextField);
            make.width.equalTo(@92);
        }];
    }
    return _countDownBtn;
}
 */


//
//  JJLoginUsePhoneNumberViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJLoginForgetPasswordViewController.h"
#import "JJInPutTextField.h"
#import "JJLoginBtn.h"
#import "JJSignUpViewController.h"

@interface JJLoginForgetPasswordViewController ()

@end

@implementation JJLoginForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"手机号码";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"Login_BackCenterImage"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(315 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //请输入已注册的手机号Label
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.textColor = RGBA(228, 217, 4, 1);
    messageLabel.text = @"请输入已注册的手机号";
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerBackImageView.mas_top).with.offset(-15 *KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
    }];
    
    //输入手机号
    JJInPutTextField *passwordInputTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 102 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"请输入手机号" numberString:@"第1步" delegate:self];
    //    [phoneInputTextField.textField xp_limitTextLength:5 block:^(NSString *text) {
    //        NSLog(@" wahaha");
    //    }];
    [centerBackImageView addSubview:passwordInputTextField];
    
    //下一步按钮
    JJLoginBtn *nextBtn = [JJLoginBtn loginBtnWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 223 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) btnName:@"下一步" numberString:@"第2步" target:self action:@selector(btnClick)];
    [centerBackImageView addSubview:nextBtn];
}

//下一步按钮点击  进入验证码页面
- (void)btnClick {
    JJSignUpViewController *signUpVC = [[JJSignUpViewController alloc]init];
    signUpVC.name = @"忘记密码";
    [self.navigationController pushViewController:signUpVC animated:YES];
}

@end

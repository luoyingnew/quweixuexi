//
//  JJSignUpViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSignUpViewController.h"
#import "JJInPutTextField.h"
#import "JJLoginBtn.h"
#import "JKCountDownButton.h"
#import "UITextField+LimitLength.h"
#import "JJSignUpPasswortViewController.h"
#import "SVProgressHUD.h"
#import "JJAgreementViewController.h"
#import "PooCodeView.h"

@interface JJSignUpViewController ()

//电话textField
@property (nonatomic, strong)JJInPutTextField *phoneInputTextField;
//验证码textField
@property (nonatomic, strong) JJInPutTextField *countDownTextField2;
//验证码
@property (nonatomic, strong) JKCountDownButton *countDownBtn;

//图像验证码textfield
@property (nonatomic, strong) JJInPutTextField *imageCodeTextField;

//图像验证码
@property (nonatomic, strong) PooCodeView *pooCodeView;

@end

@implementation JJSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = self.name;
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
    //快来开启fun学之旅吧Label
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.textColor = RGBA(146, 241, 255, 1);
    messageLabel.text = @"快来开启Fun学之旅吧!";
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerBackImageView.mas_top).with.offset(-15 *KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
    }];
    
    //输入手机号
    JJInPutTextField *phoneInputTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 40 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"请输入手机号码" numberString:@"第1步" delegate:self];
    phoneInputTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneInputTextField = phoneInputTextField;
    [centerBackImageView addSubview:phoneInputTextField];
    
    
    
    //图像验证码textfield
    JJInPutTextField *imageCodeTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 102 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"请输入图形验证码" numberString:@"第2步" delegate:self];
    self.imageCodeTextField = imageCodeTextField;
    [centerBackImageView addSubview:imageCodeTextField];
    //图像验证码
    PooCodeView *pooCodeView = [[PooCodeView alloc] init];
    self.pooCodeView = pooCodeView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [pooCodeView addGestureRecognizer:tap];
    [self.view addSubview:_pooCodeView];
    [pooCodeView createBordersWithColor:[UIColor clearColor] withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:2 * KWIDTH_IPHONE6_SCALE];
    [imageCodeTextField addSubview:_countDownBtn];
    [pooCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(imageCodeTextField.textField);
        make.width.mas_equalTo(90*KWIDTH_IPHONE6_SCALE);
    }];
    
    
    
    
    
    
    //输入验证码
    JJInPutTextField *countDownTextField2 = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 160 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"请输入验证码" numberString:@"第3步" delegate:self];
    self.countDownTextField2 = countDownTextField2;
        [centerBackImageView addSubview:countDownTextField2];
    //发送验证码按钮
    self.countDownBtn = [[JKCountDownButton alloc]init];
    
    self.countDownBtn.backgroundColor = RGBA(25, 168, 255, 1);
//    [self.countDownBtn.titleLabel setTextColor:[UIColor blackColor]];
    [self.countDownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.countDownBtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.countDownBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [countDownTextField2 addSubview:_countDownBtn];
    [self.countDownBtn setTitle:@"发送验证" forState:UIControlStateNormal];
//    [self.countDownBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    _countDownBtn.titleLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
    weakSelf(weakSelf);
    
    [_countDownBtn countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        if (!_phoneInputTextField.textField.text.length || ![Util isMobileNumber:_phoneInputTextField.textField.text]) {
            [JJHud showToast:@"请输入正确的手机号"];
            return;
        }
        //    if (![Util isMobileNumber:_phoneInputTextField.textField.text]) {
        //        [JJHud showToast:@"请输入正确的手机号"];
        //        return;
        //    }
        [weakSelf requestForVerifyCode];

        
        [weakSelf.view endEditing:YES];
        sender.enabled = NO;
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
    [self.countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(countDownTextField2.textField);
        make.width.mas_equalTo(90*KWIDTH_IPHONE6_SCALE);
    }];
    
    //下一步按钮
    JJLoginBtn *nextBtn = [JJLoginBtn loginBtnWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 237 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) btnName:@"下一步" numberString:@"第4步" target:self action:@selector(nextBtnClick)];
    [centerBackImageView addSubview:nextBtn];
    
    
    UIView *protocolView = [[UIView alloc]init];
    [centerBackImageView addSubview:protocolView];
    [protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nextBtn.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UILabel *protocolLabel = [[UILabel alloc]init];
    [protocolLabel jj_setLableStyleWithBackgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE] text:@"*注册即代表您同意" textColor:RGBA(153,153,153,1) textAlignment:NSTextAlignmentCenter];
    
    //用户许可协议按钮
    UIButton *userProtocolBtn = [[UIButton alloc]init];
    [userProtocolBtn setTitle:@"<<用户服务协议>>" forState:UIControlStateNormal];
    [userProtocolBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    [userProtocolBtn.titleLabel setFont:[UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE]];
    [protocolView addSubview:userProtocolBtn];
    [protocolView addSubview:protocolLabel];
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(protocolView);
        make.right.equalTo(userProtocolBtn.mas_left);
    }];
    [userProtocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(protocolView);
    }];
    [userProtocolBtn addTarget:self action:@selector(pushToUserProtocol) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击图像验证码
- (void)tapClick:(UITapGestureRecognizer*)tap{
    [_pooCodeView changeCode];
    NSLog(@"%@",_pooCodeView.changeString);
}

#pragma mark - 进入用户协议界面
- (void)pushToUserProtocol {
    JJAgreementViewController *agreementViewController = [[JJAgreementViewController alloc]init];
    [self.navigationController pushViewController:agreementViewController animated:YES];
}

#pragma mark - 验证码按钮点击
- (void)sendCodeAction:(UIButton *)button {
    NSLog(@"fsd");
    if (!_phoneInputTextField.textField.text.length) {
        [JJHud showToast:@"请输入正确的手机号"];
        return;
    }
//    if (![Util isMobileNumber:_phoneInputTextField.textField.text]) {
//        [JJHud showToast:@"请输入正确的手机号"];
//        return;
//    }
    [self requestForVerifyCode];
}

//获取验证码请求
- (void)requestForVerifyCode {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SEND_V_CODE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *mobileString = _phoneInputTextField.textField.text;
    [params setObject:mobileString forKey:@"mobile"];
    /**
     *  成功返回
     {
     "error_code": 0,
     "v_code": "1212"
     }
     */
    if (![Util isNetWorkEnable]) {//先判断网络状态
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
//        NSLog(@"hj%@",response);
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}




//下一步按钮点击
- (void)nextBtnClick {
    [self.view endEditing:YES];
    DebugLog(@"sf");
     if (!_phoneInputTextField.textField.text.length) {
        [JJHud showToast:@"请输入正确的手机号"];
        return;
    }
    if (!self.imageCodeTextField.textField.text.length) {
        [JJHud showToast:@"请输入图形验证码"];
        return;
    }
    if([self.imageCodeTextField.textField.text compare:self.pooCodeView.changeString options:NSCaseInsensitiveSearch] != NSOrderedSame) {
        [JJHud showToast:@"图形验证码输入错误"];
        return;
    }
    if (!_countDownTextField2.textField.text.length) {
        [JJHud showToast:@"请输入验证码"];
        return;
    }
    if ([Util isNumberAndChar:_countDownTextField2.textField.text] || _countDownTextField2.textField.text.length != 4) {
        [JJHud showToast:@"验证码错误"];
        return;
    }
    
    //如果是注册
    if([self.name isEqualToString:@"注册"]) {
        [self requestToCheckCode];
    } else {
        JJSignUpPasswortViewController *signupPasswordVC = [[JJSignUpPasswortViewController alloc]init];
        signupPasswordVC.name = self.name;
        signupPasswordVC.mobile = self.phoneInputTextField.textField.text;
        signupPasswordVC.v_code = self.countDownTextField2.textField.text;
        [self.navigationController pushViewController:signupPasswordVC animated:YES];
    }
    
}

//校验验证码请求
- (void)requestToCheckCode {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    [JJHud showStatus:nil];
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_CHECK_V_CODE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneInputTextField.textField.text forKey:@"mobile"];
    //    [params setObject:self.passwordTextField.textField.text forKey:@"password"];
    [params setObject:self.countDownTextField2.textField.text forKey:@"v_code"];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        if([response[@"is_register"] boolValue] == YES) {
            [JJHud showToast:@"该手机号已注册"];
            return;
        }
        JJSignUpPasswortViewController *signupPasswordVC = [[JJSignUpPasswortViewController alloc]init];
        signupPasswordVC.name = self.name;
        signupPasswordVC.mobile = self.phoneInputTextField.textField.text;
        [self.navigationController pushViewController:signupPasswordVC animated:YES];
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}
@end

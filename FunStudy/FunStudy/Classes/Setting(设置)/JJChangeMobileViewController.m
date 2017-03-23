//
//  JJChangeMobileViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJChangeMobileViewController.h"
#import "JJSettingInputTextField.h"
#import "JKCountDownButton.h"
#import "UIViewController+KeyboardCorver.h"
#import "PooCodeView.h"

@interface JJChangeMobileViewController ()
//修改手机号
@property (nonatomic, strong) JJSettingInputTextField *changeMobiletextField;
//验证码
@property (nonatomic, strong) JJSettingInputTextField *codetextField;

//图像验证码textfield
@property (nonatomic, strong) JJSettingInputTextField *imageCodeTextField;

//图像验证码
@property (nonatomic, strong) PooCodeView *pooCodeView;

@end

@implementation JJChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    //[self addNotification];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"变更手机";
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
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(99 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //保存按钮
    UIButton *saveBtn = [[UIButton alloc]init];
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"settingSaveBtn"] forState:UIControlStateNormal];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(65 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-41 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(54 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(23 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //修改手机号
    JJSettingInputTextField *changeMobiletextField = [JJSettingInputTextField settingInputTextFieldWithTypeString:@"修改手机号:" placeHolder:@"请输入手机号"];
    self.changeMobiletextField = changeMobiletextField;
    [changeMobiletextField createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [centerBackImageView addSubview:changeMobiletextField];
    [changeMobiletextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView);
        make.top.with.offset(38 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //图形验证码textField
    JJSettingInputTextField *imageCodetextField = [JJSettingInputTextField settingInputTextFieldWithTypeString:@"图形验证码:" placeHolder:@"请输入验证码"];
    self.imageCodeTextField = imageCodetextField;
    [imageCodetextField createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [centerBackImageView addSubview:imageCodetextField];
    [imageCodetextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView);
        make.top.equalTo(changeMobiletextField.mas_bottom).with.offset(52 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
    }];
    //图像验证码
    PooCodeView *pooCodeView = [[PooCodeView alloc] init];
    self.pooCodeView = pooCodeView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [pooCodeView addGestureRecognizer:tap];
    [self.view addSubview:_pooCodeView];
    [pooCodeView createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0 * KWIDTH_IPHONE6_SCALE];
    [imageCodetextField addSubview:pooCodeView];
    [pooCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(imageCodetextField);
        make.width.mas_equalTo(80*KWIDTH_IPHONE6_SCALE);
    }];

    
    
    
    
    //验证码
    JJSettingInputTextField *codetextField = [JJSettingInputTextField settingInputTextFieldWithTypeString:@"验证码:" placeHolder:@"请输入验证码"];
    self.codetextField = codetextField;
    [codetextField createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [centerBackImageView addSubview:codetextField];
    [codetextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView);
        make.top.equalTo(imageCodetextField.mas_bottom).with.offset(52 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
    }];
    //获取验证码按钮
    JKCountDownButton *getCodeBtn = [[JKCountDownButton alloc]init];
    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"settingButtonBack"] forState:UIControlStateNormal];
    [getCodeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:11 * KWIDTH_IPHONE6_SCALE]];
    //    [self.countDownBtn.titleLabel setTextColor:[UIColor blackColor]];
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.countDownBtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [codetextField addSubview:getCodeBtn];
    [getCodeBtn setTitle:@"发送验证" forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
    weakSelf(weakSelf);
    [getCodeBtn countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        [weakSelf.view endEditing:YES];
        sender.enabled = NO;
        [sender startCountDownWithSecond:60];
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"重新获取";
        }];
    }];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(7 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-7 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-11 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(60 * KWIDTH_IPHONE6_SCALE);
    }];
}

//保存按钮点击
- (void)saveBtnClick:(UIButton *)btn {
    if(![Util isMobileNumber: self.changeMobiletextField.textField.text]) {
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

    
    if(self.codetextField.textField.text.length == 0) {
        [JJHud showToast:@"请输入验证码"];
        return;
    }
    [self requestChangeMobile];
}

//变更手机号请求
- (void)requestChangeMobile {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_CHANGE_MOBILE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.changeMobiletextField.textField.text forKey:@"mobile"];
    [params setObject:self.codetextField.textField.text forKey:@"v_code"];
    [params setObject:[User getUserInformation].fun_user_id forKey:@"fun_user_id"];
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
        User *user = [User getUserInformation];
        user.mobile = self.changeMobiletextField.textField.text;
        [User saveUserInformation:user];
        [JJHud showToast:@"修改手机号成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

//验证码按钮点击
- (void)sendCodeAction:(UIButton *)btn {
    if(![Util isMobileNumber: self.changeMobiletextField.textField.text]) {
        [JJHud showToast:@"请输入正确的手机号"];
        return;
    }
    [self requestForVerifyCode];
}

//获取验证码请求
- (void)requestForVerifyCode {
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SEND_V_CODE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *mobileString = self.changeMobiletextField.textField.text;
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


- (void)dealloc {
    //[self clearNotificationAndGesture];
}
@end

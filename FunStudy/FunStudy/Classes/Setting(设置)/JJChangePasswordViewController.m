//
//  JJChangePasswordViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJChangePasswordViewController.h"
#import "JJSettingInputTextField.h"

@interface JJChangePasswordViewController ()

//新的登录密码
@property (nonatomic, strong) JJSettingInputTextField *pwdNewTextField;
//
//新的登录密码
@property (nonatomic, strong) JJSettingInputTextField *pwdNewOnceAgainTextField;

//原始密码
@property (nonatomic, strong) JJSettingInputTextField *oldPwdTextField;
@end

@implementation JJChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"修改密码";
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
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"settingSaveBtn"] forState:UIControlStateNormal];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(65 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-41 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(54 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(23 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //原始密码
    JJSettingInputTextField *oldPwdTextField = [JJSettingInputTextField settingInputTextFieldWithTypeString:@"原始密码:" placeHolder:@"请输入密码"];
    self.oldPwdTextField = oldPwdTextField;
    self.oldPwdTextField.textField.secureTextEntry = YES;
    [oldPwdTextField createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [centerBackImageView addSubview:oldPwdTextField];
    [oldPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView);
        make.top.with.offset(38 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //新的登录密码
    JJSettingInputTextField *newPwdTextField = [JJSettingInputTextField settingInputTextFieldWithTypeString:@"新的登录密码:" placeHolder:@"请输入新密码"];
    self.pwdNewTextField = newPwdTextField;
    self.pwdNewTextField.textField.secureTextEntry = YES;
    [newPwdTextField createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [centerBackImageView addSubview:newPwdTextField];
    [newPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView);
        make.top.equalTo(oldPwdTextField.mas_bottom).with.offset(32 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
    }];

    //新的登录密码
    JJSettingInputTextField *newPwdOnceAgainTextField = [JJSettingInputTextField settingInputTextFieldWithTypeString:@"再次输入新密码:" placeHolder:@"请再次输入新密码"];
    self.pwdNewOnceAgainTextField = newPwdOnceAgainTextField;
    self.pwdNewOnceAgainTextField.textField.secureTextEntry = YES;
    [newPwdOnceAgainTextField createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [centerBackImageView addSubview:newPwdOnceAgainTextField];
    [newPwdOnceAgainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView);
        make.top.equalTo(newPwdTextField.mas_bottom).with.offset(32 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(300 * KWIDTH_IPHONE6_SCALE);
    }];

}


//完成按钮点击
- (void)saveBtnClick {
    if (self.oldPwdTextField.textField.text.length == 0) {
        [JJHud showToast:@"请输入原始密码"];
        return;
    }
    if (self.pwdNewTextField.textField.text.length == 0) {
        [JJHud showToast:@"请输入新的密码"];
        return;
    }
    if (self.pwdNewOnceAgainTextField.textField.text.length == 0) {
        [JJHud showToast:@"请再次输入新的密码"];
        return;
    }
    if (![self.pwdNewTextField.textField.text isEqualToString:( self.pwdNewOnceAgainTextField.textField.text)]) {
        [JJHud showToast:@"输入密码不一致"];
        return;
    }
    
    [self requestToChangePassword];
    
}
//发送修改密码请求
- (void)requestToChangePassword {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_UPDATE_PWD];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id, @"old_password" : self.oldPwdTextField.textField.text, @"new_password" : self.pwdNewTextField.textField.text, @"verify_password" : self.pwdNewOnceAgainTextField.textField.text};
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
        user.token = response[@"token"];
        [User saveUserInformation:user];
        [JJHud showToast:@"修改密码成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}


@end

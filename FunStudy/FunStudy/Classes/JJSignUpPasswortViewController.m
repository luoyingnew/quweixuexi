//
//  JJSignUpPasswortViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSignUpPasswortViewController.h"
#import "JJInPutTextField.h"
#import "JJLoginBtn.h"
#import "JJSearchTeacherViewController.h"
#import "JJTabbarController.h"
#import "JJLoginViewController.h"
#import "JPUSHService.h"

@interface JJSignUpPasswortViewController ()

//首次输入密码
@property (nonatomic, strong) JJInPutTextField *passwordInputTextField;
//再次输入密码
@property (nonatomic, strong) JJInPutTextField *passwordRepeatInputTextField;
//密码不一致提示
@property (nonatomic, strong) UILabel *errorTipLabel;

@end

@implementation JJSignUpPasswortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    // Do any additional setup after loading the view.
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
    
    //首次输入密码
    JJInPutTextField *passwordInputTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 91 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"请输入密码" numberString:@"第1步" delegate:self];
    passwordInputTextField.textField.secureTextEntry = YES;
    self.passwordInputTextField = passwordInputTextField;
    //    [phoneInputTextField.textField xp_limitTextLength:5 block:^(NSString *text) {
    //        NSLog(@" wahaha");
    //    }];
    [centerBackImageView addSubview:passwordInputTextField];
    
    //再次输入密码
    JJInPutTextField *passwordRepeatInputTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 160 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"请重复输入密码" numberString:@"第2步" delegate:self];
    passwordRepeatInputTextField.textField.secureTextEntry = YES;
    self.passwordRepeatInputTextField = passwordRepeatInputTextField;
    [centerBackImageView addSubview:passwordRepeatInputTextField];
    
    //再次输入的密码不一致
    UILabel *errorTipLabel = [[UILabel alloc]init];
    self.errorTipLabel = errorTipLabel;
    errorTipLabel.hidden = YES;
    errorTipLabel.text = @"再次输入的密码不一致";
    errorTipLabel.font = [UIFont systemFontOfSize:13];
    errorTipLabel.textColor = RGBA(230, 86, 98, 1);
    [centerBackImageView addSubview:errorTipLabel];
    [errorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordRepeatInputTextField.mas_bottom);
        make.left.equalTo(passwordRepeatInputTextField).with.offset(26 * KWIDTH_IPHONE6_SCALE);
    }];
    
    JJLoginBtn *loginBtn = [JJLoginBtn loginBtnWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 237 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) btnName:@"完成" numberString:@"第3步" target:self action:@selector(btnClick)];
    [centerBackImageView addSubview:loginBtn];
}

//完成按钮点击
- (void)btnClick {
    if (![self.passwordRepeatInputTextField.textField.text isEqualToString:self.passwordInputTextField.textField.text]) {
        [JJHud showToast:@"密码不一致"];
        self.errorTipLabel.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.errorTipLabel.hidden = YES;
        });
        return;
    }
    if (self.passwordInputTextField.textField.text.length == 0 || self.passwordRepeatInputTextField.textField.text.length == 0) {
        [JJHud showToast:@"请补全密码"];
        return;
    }
    //如果是注册
    if ([self.name isEqualToString:@"注册"]) {
        [self requestToSignUp];
    } else {
        //如果是忘记密码
        [self requestToForgetPassword];
    }
    
}
//发送注册请求
- (void)requestToSignUp {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_SIGNUP];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.mobile forKey:@"mobile"];
    [params setObject:self.passwordInputTextField.textField.text forKey:@"password1"];
    [params setObject:self.passwordRepeatInputTextField.textField.text forKey:@"password2"];
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
        User *user = [User mj_objectWithKeyValues:response[@"fun_user"]];
        user.mobile = self.mobile;
        user.token = response[@"token"];
        [User saveUserInformation:user];
        [self networkDidSetup];
        [JJHud showToast:@"注册成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JJTabbarController *tabbarController = [[JJTabbarController alloc]init];
            //        [self.navigationController pushViewController:tabbarController animated:YES];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbarController;
        });
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}


#pragma mark -- 极光推送回调方法
- (void)networkDidSetup
{
    // 获取当前用户id，上报给极光，用作别名
    User *user = [User getUserInformation];
    //针对设备给极光服务器反馈了别名，app服务端可以用别名来针对性推送消息
    [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%@", user.fun_user_id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"极光推送错误码+++++++：%d", iResCode);
        
        if (iResCode == 0) {
            NSLog(@"极光推送：设置别名成功, 别名：%@", user.fun_user_id);
        }
    }];
}

//发送修改密码请求
- (void)requestToForgetPassword {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_FORGET_PWD];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.mobile forKey:@"mobile"];
    [params setObject:self.passwordInputTextField.textField.text forKey:@"password"];
    [params setObject:self.v_code forKey:@"v_code"];
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
//        User *user = [User mj_objectWithKeyValues:response[@"fun_user"]];
//        user.token = response[@"token"];
//        [User saveUserInformation:user];
        [JJHud showToast:@"修改密码成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            JJTabbarController *tabbarController = [[JJTabbarController alloc]init];
//            //        [self.navigationController pushViewController:tabbarController animated:YES];
//            [UIApplication sharedApplication].keyWindow.rootViewController = tabbarController;
            JJLoginViewController *loginViewController = [[JJLoginViewController alloc]init];
            [self.navigationController pushViewController:loginViewController animated:YES];
        });
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

@end

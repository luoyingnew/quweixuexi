//
//  JJLoginViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJLoginViewController.h"
#import "XPAlertController.h"
#import "JJInPutTextField.h"
#import "JJLoginBtn.h"
#import "JJIssueActionView.h"
#import "JJLoginForgetPasswordViewController.h"
#import "JJHelpCenterViewController.h"
#import "JJFunStudyViewController.h"
#import "JJTabbarController.h"
#import "JJSignUpViewController.h"
#import "JPUSHService.h"

@interface JJLoginViewController ()<JJIssueActionViewDelegate>

////弹框提示
//@property (nonatomic, strong) JJIssueActionView *actionSheetView;
//账号
@property (nonatomic, strong) JJInPutTextField *phoneInputTextField;
//密码
@property (nonatomic, strong) JJInPutTextField *passwordTextField;


@end

@implementation JJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    // Do any additional setup after loading the view.
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"登录";
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
    
    //输入手机号或学号
    JJInPutTextField *phoneInputTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 91 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"请输入手机号码或Fun学号" numberString:@"第1步" delegate:self];
    self.phoneInputTextField = phoneInputTextField;
    //    [phoneInputTextField.textField xp_limitTextLength:5 block:^(NSString *text) {
    //        NSLog(@" wahaha");
    //    }];
    [centerBackImageView addSubview:phoneInputTextField];
    
    //输入密码
    JJInPutTextField *passwordTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 160 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"请输入密码" numberString:@"第2步" delegate:self];
    passwordTextField.textField.secureTextEntry = YES;
    self.passwordTextField = passwordTextField;
    [centerBackImageView addSubview:passwordTextField];
    
    //登录遇到问题
    UIButton *issueBtn = [[UIButton alloc]init];
    [issueBtn.titleLabel setFont:[UIFont systemFontOfSize:13 * KWIDTH_IPHONE6_SCALE]];
    [issueBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [issueBtn addTarget:self action:@selector(showActionView) forControlEvents:UIControlEventTouchUpInside];
    [issueBtn setTitleColor:RGBA(65, 172, 245, 1) forState:UIControlStateNormal];
    [centerBackImageView addSubview:issueBtn];
    [issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordTextField.mas_bottom);
        make.right.equalTo(passwordTextField).with.offset(-9 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(14 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //登录按钮
    JJLoginBtn *loginBtn = [JJLoginBtn loginBtnWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 237 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) btnName:@"下一步" numberString:@"第3步" target:self action:@selector(btnClick)];
    [centerBackImageView addSubview:loginBtn];
}

//登录click
- (void)btnClick {
    
    if (!self.phoneInputTextField.textField.text.length) {
        
        [JJHud showToast:@"请输入手机号"];
        return;
    }
    if (!_passwordTextField.textField.text.length) {
        [JJHud showToast:@"请输入密码"];
        return;
    }

    [self requestToLogin];
}

//登录请求Request
- (void)requestToLogin {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_LOGIN];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneInputTextField.textField.text forKey:@"user_name"];
    [params setObject:self.passwordTextField.textField.text forKey:@"password"];
    [params setObject:[Util getClientIP] forKey:@"login_ip"];
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
        user.token = response[@"token"];
        user.wait_homework = NO;
        user.new_homework = NO;
        user.new_test = NO;
        [User saveUserInformation:user];
        [self networkDidSetup];
        [JJHud showToast:@"登录成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JJTabbarController *tabbarController = [[JJTabbarController alloc]init];
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

//显示actionView
- (void)showActionView {
//    [self.actionSheetView actionViewShow];
    JJSignUpViewController *signUpVC = [[JJSignUpViewController alloc]init];
    signUpVC.name = @"忘记密码";
    [self.navigationController pushViewController:signUpVC animated:YES];

}

//#pragma mark - JJIssueActionViewDelegate
//- (void)actionViewDidSelectedIndex:(NSInteger)index {
//    
//    if(index == 0) {
//        //忘记密码
//        JJSignUpViewController *signUpVC = [[JJSignUpViewController alloc]init];
//        signUpVC.name = @"忘记密码";
//        [self.navigationController pushViewController:signUpVC animated:YES];
//    } else if(index == 1) {
//        //进入帮助中心
//        JJHelpCenterViewController *helpCenterVC= [[JJHelpCenterViewController alloc]init];
//        [self.navigationController pushViewController:helpCenterVC animated:YES];
//    }
//}

////懒加载
//- (JJIssueActionView *)actionSheetView {
//    if (!_actionSheetView) {
//        _actionSheetView = [[JJIssueActionView alloc]initWithFrame:self.view.bounds];
//        _actionSheetView.delegate = self;
//        [self.view addSubview:_actionSheetView];
//    }
//    return _actionSheetView;
//}


- (void)dealloc {
    DebugLog(@"销毁了");
}
@end

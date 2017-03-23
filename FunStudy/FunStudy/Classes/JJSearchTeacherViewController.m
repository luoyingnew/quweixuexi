//
//  JJSearchTeacherViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSearchTeacherViewController.h"
#import "JJInPutTextField.h"
#import "JJLoginBtn.h"
#import "JJTabbarController.h"
#import "JJJoinClassViewController.h"
#import "JJWordSpellingViewController.h"
#import "UINavigationController+XPShouldPop.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface JJSearchTeacherViewController ()//<UITextFieldDelegate,UINavigationControllerShouldPop>

@property (nonatomic, strong) JJInPutTextField *teacherInputTextField;


@end

@implementation JJSearchTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    self.fd_interactivePopDisabled = YES;
    
//    //加上左划手势
//    UIScreenEdgePanGestureRecognizer * screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(leftBarButtonClick)];
//    screenEdgePanGesture.edges = UIRectEdgeLeft;
//    [self.view addGestureRecognizer:screenEdgePanGesture];
}

//左端按钮点击事件
- (void)leftBarButtonClick {
   [self.navigationController popToRootViewControllerAnimated:NO];
   [[NSNotificationCenter defaultCenter]postNotificationName:POP object:@0];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
//    });

//    [self dismissViewControllerAnimated:NO completion:^{
//            }];
    
}
#pragma mark - 基本设置
- (void)setUpBaseView{
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
    
    //找到你的老师
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.textColor = RGBA(146, 241, 255, 1);
    messageLabel.text = @"找到你的老师";
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerBackImageView.mas_top).with.offset(-15 *KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
    }];
    
    //输入老师给的号码加入班级
    JJInPutTextField *teacherInputTextField = [JJInPutTextField inputTextFieldWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 102 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) WithPlaceholder:@"输入老师给的号码加入班级" numberString:@"第1步" delegate:self];
    self.teacherInputTextField = teacherInputTextField;
    //    [phoneInputTextField.textField xp_limitTextLength:5 block:^(NSString *text) {
    //        NSLog(@" wahaha");
    //    }];
    [centerBackImageView addSubview:self.teacherInputTextField];
    
    //下一步按钮
    JJLoginBtn *nextBtn = [JJLoginBtn loginBtnWithFrame:CGRectMake(11 * KWIDTH_IPHONE6_SCALE, 223 * KWIDTH_IPHONE6_SCALE, 282 * KWIDTH_IPHONE6_SCALE, 52 * KWIDTH_IPHONE6_SCALE) btnName:@"下一步" numberString:@"第2步" target:self action:@selector(searchTeacherBtnClick)];
    [centerBackImageView addSubview:nextBtn];
}


////是否有新作业  首页轮播
//- (void)requestTheHomeWork {
//    if (![Util isNetWorkEnable]) {
//        return;
//    }
//    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_CAROUSEL];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[User getUserInformation].fun_user_id forKey:@"user_id"];
//    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        DebugLog(@"response = %@", response);
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        if (codeValue) { //详情数据加载失败
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            DebugLog(@"codeMessage = %@", codeMessage);
//            return ;
//        }
//        User *currentUser = [User getUserInformation];
//        User *user = [User mj_objectWithKeyValues:response];
//        currentUser.new_test = user.new_test;
//        currentUser.new_homework = user.new_homework;
//        currentUser.wait_homework = user.wait_homework;
//        currentUser.user_class = user.user_class;
//        
//        [User saveUserInformation:currentUser];
//        User *u = [User getUserInformation];
//        //如果有班级
//        if(currentUser.user_class) {
//            //发出通知让首页和tabbar修改
//            [[NSNotificationCenter defaultCenter]postNotificationName:SuccessJoinClass object:nil];
//        }
//        
//    } fail:^(NSError *error) {
//        //        [JJHud showToast:@"加载失败"];
//    }];
//    
//}


//下一步按钮点击
- (void)searchTeacherBtnClick {
    if (!_teacherInputTextField.textField.text.length) {
        [JJHud showToast:@"请输入老师给的号码加入班级"];
        return;
    }
    [self requestToSearchTeacher];
}

//发送找到老师请求
- (void)requestToSearchTeacher {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    [JJHud showStatus:nil];
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_FINE_TEACHER];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.teacherInputTextField.textField.text forKey:@"conditions"];
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
        
        JJTeacherModel *teacherModel = [JJTeacherModel mj_objectWithKeyValues:response];
        
        JJJoinClassViewController *joinClassVC = [[JJJoinClassViewController alloc]init];
        joinClassVC.teacherModel = teacherModel;
        [self.navigationController pushViewController:joinClassVC animated:YES];
//        JJSignUpPasswortViewController *signupPasswordVC = [[JJSignUpPasswortViewController alloc]init];
//        signupPasswordVC.name = self.name;
//        signupPasswordVC.mobile = self.phoneInputTextField.textField.text;
//        [self.navigationController pushViewController:signupPasswordVC animated:YES];
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

//#pragma mark - UINavigationControllerShouldPopDelegate
//- (BOOL)navigationControllerShouldPop:(UINavigationController *)navigationController
//{
//    DebugLog(@"eeeeee");
//    //    @weakify(self);
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //        @strongify(self);
////        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self leftBarButtonClick];
////        [self.navigationController popToRootViewControllerAnimated:NO];
////        [[NSNotificationCenter defaultCenter]postNotificationName:POP object:@0];
//        
////    });
//    return NO;
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

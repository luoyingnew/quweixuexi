//
//  FeedbackViewController.m
//  FunStudy
//
//  Created by tang on 16/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "FeedbackViewController.h"
#import "XPTextView.h"
#import "UITextField+LimitLength.h"
//#import "UIViewController+KeyboardCorver.h"

@interface FeedbackViewController ()

@property (nonatomic, strong)XPTextView *textView;
@property (nonatomic, strong)UITextField *mobileField;
//scrollV主要是为了配合IQKeyboardManager
@property (nonatomic, strong) UIScrollView *scrollV;;


@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBaseView];
    [self setNavigationBar];
    [self showView];
    //[self addNotification];
}

//设置背景图
- (void)setBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    UIScrollView *scro = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollV = scro;
    //self.scrollV.backgroundColor = [UIColor redColor];
    [backImageView addSubview:scro];
    scro.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height-100 );
    
}
//设置导航条
- (void)setNavigationBar {
    self.titleName = @"用户反馈";
}

//y 97
//h 480  w 340
- (void)showView
{
    //白色背景
    UIImageView *backImageView = [[UIImageView alloc]init ];//WithFrame:CGRectMake((SCREEN_WIDTH - 340 *KWIDTH_IPHONE6_SCALE)/2, 97*KWIDTH_IPHONE6_SCALE, 340*KWIDTH_IPHONE6_SCALE, 445*KWIDTH_IPHONE6_SCALE)];
    backImageView.userInteractionEnabled = YES;
    backImageView.backgroundColor = [UIColor whiteColor];
    [backImageView.layer setCornerRadius:10.0*KWIDTH_IPHONE6_SCALE];
    [backImageView.layer setMasksToBounds:YES];
    [self.scrollV addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.with.offset(93 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(321 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(451 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feedBack_icon"]];
    [backImageView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(backImageView).offset(15*KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(backImageView).offset(15*KWIDTH_IPHONE6_SCALE);
        make.size.mas_equalTo(CGSizeMake(53*KWIDTH_IPHONE6_SCALE, 53*KWIDTH_IPHONE6_SCALE));
    }];
    
    //topImageView  有什么建议或感受告诉我们
    UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingTopBack"]];
    topImageView.userInteractionEnabled = YES;
    [backImageView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(backImageView).offset(24*KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(iconView.mas_right).offset(4 *KWIDTH_IPHONE6_SCALE);
        make.size.mas_equalTo(CGSizeMake(233*KWIDTH_IPHONE6_SCALE, 85*KWIDTH_IPHONE6_SCALE));
    }];
    
    //centerImageView    我的建议是
    UIImageView *centerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingCenterBack"]];
    centerImageView.userInteractionEnabled = YES;
    [backImageView addSubview:centerImageView];
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topImageView.mas_bottom).offset(9*KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(backImageView);
        make.size.mas_equalTo(CGSizeMake(285*KWIDTH_IPHONE6_SCALE, 183*KWIDTH_IPHONE6_SCALE));
    }];
    XPTextView *textView = [[XPTextView alloc]init];
    self.textView = textView;
    textView.font = [UIFont boldSystemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
    textView.placeholder = @"我的建议是(255字以内)";
    textView.maxInputLength = 255;
//    textView.backgroundColor = [UIColor redColor];
    [centerImageView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(30*KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(26*KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-26 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-36 *KWIDTH_IPHONE6_SCALE);
        
    }];
    //bottomImageView    请输入你的手机号
    UIImageView *bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingBottomBack"]];
//    bottomImageView.backgroundColor = [UIColor greenColor];
    bottomImageView.userInteractionEnabled = YES;
    [backImageView addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(centerImageView.mas_bottom).offset(11*KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(backImageView);
        make.size.mas_equalTo(CGSizeMake(276*KWIDTH_IPHONE6_SCALE, 59*KWIDTH_IPHONE6_SCALE));
    }];
    
//
    UITextField *mobileField = [[UITextField alloc]init];
    self.mobileField = mobileField;
    [mobileField xp_limitTextLength:11 block:nil];
//    mobileField.backgroundColor = [UIColor redColor];
    mobileField .font = [UIFont boldSystemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
//    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5*KWIDTH_IPHONE6_SCALE, 0)];
//    mobileField.leftView = leftView;
//    mobileField.leftViewMode = UITextFieldViewModeAlways;
    mobileField.placeholder = @"请输入你的手机号...";
    [bottomImageView addSubview:mobileField];
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.with.offset(10*KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-10 *KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(28*KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-28 *KWIDTH_IPHONE6_SCALE);
    }];
//
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(submitFeedBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"loginOutBack"] forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
    [submitBtn setTitle:@"提交建议" forState:UIControlStateNormal];
    [backImageView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView).offset(28*KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(backImageView).offset(-28*KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-14*KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(42*KWIDTH_IPHONE6_SCALE);
    }];
    
}

#pragma mark - 提交按钮点击
- (void)submitFeedBackBtnClick {
    if(self.textView.text.length == 0) {
        [JJHud showToast:@"请输入您的建议再进行提交"];
        return;
    }
    if(![Util isMobileNumber:self.mobileField.text]) {
        [JJHud showToast:@"请输入正确的手机号"];
        return;
    }
    [self submitFeedBackRequest];
}

#pragma mark - 提交反馈请求
- (void)submitFeedBackRequest {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_FEEDBACK];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id, @"content" : self.textView.text, @"mobile" : self.mobileField.text};
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
        [JJHud showToast:@"提交成功"];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
    

}
@end

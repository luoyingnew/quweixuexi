//
//  JJLoginOrSignUpViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJLoginOrSignUpViewController.h"
#import "JJSignUpViewController.h"
#import "JJLoginViewController.h"

@interface JJLoginOrSignUpViewController ()

@end

@implementation JJLoginOrSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationViewBg.hidden = YES;
    [self setUpBaseView];
}

//基本设置
- (void)setUpBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"Login_BackImage"];
    [self.view addSubview:backImageView];
    
    //注册按钮
    UIButton *signUpBtn = [[UIButton alloc]init];
    [signUpBtn setBackgroundImage:[UIImage imageNamed:@"signupBtnImage"] forState:UIControlStateNormal];
//    [signUpBtn setTitle:@"注册Fun学" forState:UIControlStateNormal];
//    [signUpBtn setTitleColor:RGBA(101, 142, 242, 1) forState:UIControlStateNormal];
//    [signUpBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [signUpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
    
    [signUpBtn addTarget:self action:@selector(gotoSignUpVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtn];
    [signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(113 * KWIDTH_IPHONE6_SCALE, 25 * KWIDTH_IPHONE6_SCALE));
        make.left.mas_equalTo(KWIDTH_IPHONE6_SCALE * 45);
        make.bottom.mas_equalTo( -KWIDTH_IPHONE6_SCALE * 63);
    }];
    
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"LoginBtnImage"] forState:UIControlStateNormal];
//    [loginBtn setTitle:@"登录Fun学" forState:UIControlStateNormal];
//    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [loginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
//    [loginBtn setTitleColor:RGBA(101, 142, 242, 1) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(gotoLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(113 * KWIDTH_IPHONE6_SCALE, 25 * KWIDTH_IPHONE6_SCALE));
        make.right.mas_equalTo(- KWIDTH_IPHONE6_SCALE * 45);
        make.bottom.mas_equalTo( -KWIDTH_IPHONE6_SCALE * 63);
    }];
    
}

#pragma mark - 按钮点击
//注册页
- (void)gotoSignUpVC {
    JJSignUpViewController *signupVC = [[JJSignUpViewController alloc]init];
    signupVC.name = @"注册";
    [self.navigationController pushViewController:signupVC animated:YES];
}
//登录页
- (void)gotoLoginVC {
    JJLoginViewController *loginVC = [[JJLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end

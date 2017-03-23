//
//  JJAccountSecurityViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJAccountSecurityViewController.h"
#import "JJChangeMobileViewController.h"
#import "JJChangePasswordViewController.h"

@interface JJAccountSecurityViewController ()

@property (nonatomic, strong) UILabel *phoneNumberLabel;


@end

@implementation JJAccountSecurityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.phoneNumberLabel) {
        self.phoneNumberLabel.text = [User getUserInformation].mobile;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"账号安全";
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
    
    //修改手机号  13691328013
    UIView *accountBackView = [[UIView alloc]init];
    [accountBackView createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0 * KWIDTH_IPHONE6_SCALE ];
    [centerBackImageView addSubview:accountBackView];
    accountBackView.backgroundColor = RGBA(0, 192, 237, 1);
    [accountBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(39 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
    }];
    //x修改手机号Lable
    UILabel *changeMobileLabel = [[UILabel alloc]init];
    changeMobileLabel.text = @"修改手机号";
    changeMobileLabel.textColor = [UIColor whiteColor];
    [accountBackView addSubview:changeMobileLabel];
    changeMobileLabel.font = [UIFont boldSystemFontOfSize:21 * KWIDTH_IPHONE6_SCALE];
    [changeMobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(accountBackView);
        make.left.with.offset(5 * KWIDTH_IPHONE6_SCALE);
    }];
    //13619328032Label
    User *u = [User getUserInformation];
    UILabel *phoneNumberLabel = [[UILabel alloc]init];
    self.phoneNumberLabel = phoneNumberLabel;
    phoneNumberLabel.textColor = [UIColor whiteColor];
    phoneNumberLabel.text = [User getUserInformation].mobile;
    [accountBackView addSubview:phoneNumberLabel];
    phoneNumberLabel.font = [UIFont boldSystemFontOfSize:21 * KWIDTH_IPHONE6_SCALE];
    [phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-5 * KWIDTH_IPHONE6_SCALE);
        make.top.bottom.equalTo(accountBackView);
        make.left.equalTo(changeMobileLabel.mas_right);
    }];
    //点击跳进变更手机界面
    weakSelf(weakSelf);
    [accountBackView whenTapped:^{
        JJChangeMobileViewController *changeMobileVC = [[JJChangeMobileViewController alloc]init];
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
    }];
    
    
    
    //修改密码BackView
    UIView *passwordBackView = [[UIView alloc]init];
    [passwordBackView createBordersWithColor:[UIColor clearColor] withCornerRadius:19 * KWIDTH_IPHONE6_SCALE andWidth:0 * KWIDTH_IPHONE6_SCALE ];
    [centerBackImageView addSubview:passwordBackView];
    passwordBackView.backgroundColor = RGBA(0, 192, 237, 1);
    [passwordBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountBackView.mas_bottom).with.offset(44 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
        make.width.mas_equalTo(281 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
    }];
    //修改密码Lable
    UILabel *changePasswordLabel = [[UILabel alloc]init];
    changePasswordLabel.text = @"修改密码";
    changePasswordLabel.textColor = [UIColor whiteColor];
    [passwordBackView addSubview:changePasswordLabel];
    changePasswordLabel.font = [UIFont boldSystemFontOfSize:21 * KWIDTH_IPHONE6_SCALE];
    [changePasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(passwordBackView);
        make.left.with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-5 * KWIDTH_IPHONE6_SCALE);
    }];
    [passwordBackView whenTapped:^{
        JJChangePasswordViewController *changePasswordVC = [[JJChangePasswordViewController alloc]init];
        [weakSelf.navigationController pushViewController:changePasswordVC animated:YES];
    }];

}
@end

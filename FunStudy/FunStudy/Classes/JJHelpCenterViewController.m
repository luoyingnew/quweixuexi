//
//  JJHelpCenterViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHelpCenterViewController.h"

@interface JJHelpCenterViewController ()

@end

@implementation JJHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
//    self.titleName = @"手机号码";
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
    //帮助中心Label
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.text = @"帮助中心";
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerBackImageView.mas_top).with.offset(-15 *KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
    }];
    
    //忘记账号密码
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"忘记账号密码";
    titleLabel.textColor = [UIColor whiteColor];
    [centerBackImageView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBackImageView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerBackImageView).with.offset(43 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerBackImageView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
    }];
    //联系在线客服
    UILabel *contactLabel = [[UILabel alloc]init];
    contactLabel.font = [UIFont systemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
    contactLabel.text = @"联系在线客服（时间：9.00-21.00）";
    contactLabel.textColor = RGBA(212, 146, 0, 1);
    [centerBackImageView addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerBackImageView).with.offset(-24 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerBackImageView).with.offset(-68 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //帮助提示1
    UILabel *tipLabel1 = [[UILabel alloc]init];
    tipLabel1.text = @"1.忘记账号或密码时，可以向自己的任课老师询问。";
    tipLabel1.textColor = RGBA(0, 130, 190, 1);
    [centerBackImageView addSubview:tipLabel1];
    tipLabel1.numberOfLines = 0;
    [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBackImageView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerBackImageView).with.offset(86 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerBackImageView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
    }];
    //帮助提示2
    UILabel *tipLabel2 = [[UILabel alloc]init];
    tipLabel2.text = @"2.已绑定或注册手机号，可以通过手机号+短信验证码登录或自助找回";
    tipLabel2.textColor = RGBA(0, 130, 190, 1);
    [centerBackImageView addSubview:tipLabel2];
    tipLabel2.numberOfLines = 0;
    [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBackImageView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerBackImageView).with.offset(150 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerBackImageView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
    }];
    //帮助提示3
    UILabel *tipLabel3 = [[UILabel alloc]init];
    tipLabel3.text = @"未绑定手机号码，通过人工在线客服，提供个人详细信息证实身份证后找回。";
    tipLabel3.textColor = RGBA(0, 130, 190, 1);
    [centerBackImageView addSubview:tipLabel3];
    tipLabel3.numberOfLines = 0;
    [tipLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerBackImageView).with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(centerBackImageView).with.offset(210 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(centerBackImageView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
}

@end

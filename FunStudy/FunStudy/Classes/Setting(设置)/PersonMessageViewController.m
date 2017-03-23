//
//  PersonMessageViewController.m
//  FunStudy
//
//  Created by tang on 16/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "PersonMessageViewController.h"
#import "JJAccountSecurityViewController.h"
#import "JJMyTeacherViewController.h"
#import "JJEditPersonalMessageViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface PersonMessageViewController ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *stuLabel;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UIImageView *sexImageV;


@end

@implementation PersonMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseView];
    [self setNavigationBar];
    [self showTopView];
    [self addNotificateWithRefresh];
    //w 299 h 268
    
    // 我89
    
    [self requestWithPersonalMessage];
}
- (void)showTopView
{
     weakSelf(weakSelf);
    User *user = [User getUserInformation];
    
    UIView *backView= [[UIView alloc]init];
    [self.view addSubview:backView];
    backView.backgroundColor = RGBA(190, 246, 255, 1);
    [backView createBordersWithColor:RGBA(0, 160, 204, 1) withCornerRadius:15 * KWIDTH_IPHONE6_SCALE andWidth:4 * KWIDTH_IPHONE6_SCALE];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(323 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(452 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.top.with.offset(87 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person_back"]];
    backImageView.frame = CGRectMake((SCREEN_WIDTH - 283*KWIDTH_IPHONE6_SCALE)/2, 74*KWIDTH_IPHONE6_SCALE, 283*KWIDTH_IPHONE6_SCALE, 253*KWIDTH_IPHONE6_SCALE);
    [self.view addSubview:backImageView];
    [self.view bringSubviewToFront:backImageView];
    
    
    //编辑按钮
    UIButton *settingBtn = [[UIButton alloc]init];
    [self.navigationViewBg addSubview:settingBtn];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"FunClassRule"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(pushEdirVC) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
    [settingBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [settingBtn setTitleColor:RGBA(148, 0, 0, 1) forState:UIControlStateNormal];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-25 * KWIDTH_IPHONE6_SCALE);
        make.width.with.offset(50 * KWIDTH_IPHONE6_SCALE);
        make.height.with.offset(25 * KWIDTH_IPHONE6_SCALE);
    }];

    
    //头像
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personalIcon"]];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView = iconView;
    DebugLog(@"%@",user.avatar_url);
    [iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar_url] placeholderImage:[UIImage imageNamed:@"icon_image_new"]];
    iconView.frame = CGRectMake((backImageView.width - 95*KWIDTH_IPHONE6_SCALE)/2, 63*KWIDTH_IPHONE6_SCALE, 95*KWIDTH_IPHONE6_SCALE, 95*KWIDTH_IPHONE6_SCALE);
    [iconView.layer setCornerRadius:iconView.width/2];
    [iconView.layer setMasksToBounds:YES];
    [backImageView addSubview:iconView];
    
    //名字
    UILabel *nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    nameLabel.text = [NSString stringWithFormat:@" %@ ",user.user_nicename];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
    nameLabel.backgroundColor = NORMAL_COLOR;
    [nameLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:11 * KWIDTH_IPHONE6_SCALE andWidth:0];
//    [nameLabel.layer setCornerRadius:10.0];
//    [nameLabel.layer setMasksToBounds:YES];
    [backImageView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconView.mas_bottom).offset(5*KWIDTH_IPHONE6_SCALE);
        make.centerX.mas_equalTo(backImageView);
        make.height.mas_equalTo(22*KWIDTH_IPHONE6_SCALE);
    }];
    
    //性别头像
    UIImageView *sexImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.sexImageV = sexImageV;
    self.sexImageV.contentMode = UIViewContentModeScaleAspectFit;
    [backImageView addSubview:sexImageV];
    [sexImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).with.offset(3 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(nameLabel);
        make.width.mas_equalTo(38* KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(25 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //学号
    UILabel *stuLabel = [[UILabel alloc]init];
    self.stuLabel = stuLabel;
    [stuLabel setTextColor:RGBA(251, 255, 0, 1)];
//    stuLabel.textAlignment = NSTextAlignmentCenter;
    stuLabel.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
    stuLabel.text = [NSString stringWithFormat: @"学号:%@",user.user_code];
    [stuLabel.layer setCornerRadius:11.0 * KWIDTH_IPHONE6_SCALE];
    [stuLabel.layer setMasksToBounds:YES];
    stuLabel.backgroundColor = NORMAL_COLOR;
    [backImageView addSubview:stuLabel];
    [stuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).offset(10*KWIDTH_IPHONE6_SCALE);
        make.centerX.mas_equalTo(backImageView);
        make.height.mas_equalTo(22*KWIDTH_IPHONE6_SCALE);
    }];
    
    
    //学校
    UILabel *schoolLabel = [[UILabel alloc]init];
    self.schoolLabel = schoolLabel;
    schoolLabel .font = [UIFont boldSystemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
    NSString *text =[NSString stringWithFormat: @"所在学校：%@",user.school_name];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.headIndent = 94*KWIDTH_IPHONE6_SCALE;
    paragraphStyle.firstLineHeadIndent = -94*KWIDTH_IPHONE6_SCALE;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    schoolLabel.attributedText = attributedString;
    schoolLabel.textColor = [UIColor whiteColor];
    [schoolLabel.layer setCornerRadius:5.0 * KWIDTH_IPHONE6_SCALE];
    [schoolLabel.layer setMasksToBounds:YES];
    schoolLabel.numberOfLines = 0;
    schoolLabel.backgroundColor = NORMAL_COLOR;
    [self.view addSubview:schoolLabel];
    [schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(backImageView.mas_bottom).offset(20*KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(backImageView);
        make.right.equalTo(backImageView);
        make.height.mas_equalTo(50*KWIDTH_IPHONE6_SCALE);
        
    }];
    //班级
    UILabel *classLabel = [[UILabel alloc]init];
    self.classLabel = classLabel;
    classLabel .font = [UIFont boldSystemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
    classLabel.text = [NSString stringWithFormat:@"班级:%@",user.class_name];
    classLabel.textColor = [UIColor whiteColor];
    [classLabel.layer setCornerRadius:5.0 * KWIDTH_IPHONE6_SCALE];
    [classLabel.layer setMasksToBounds:YES];
    classLabel.backgroundColor = NORMAL_COLOR;
    [self.view addSubview:classLabel];
    [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(schoolLabel.mas_bottom).offset(5*KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(schoolLabel);
        make.right.equalTo(schoolLabel);
        make.height.mas_equalTo(30*KWIDTH_IPHONE6_SCALE);
        
    }];
    //我的老师
    UILabel *teacherLable = [[UILabel alloc]init];
    teacherLable .font = [UIFont boldSystemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
    teacherLable.text = @"我的老师";
    teacherLable.textColor = [UIColor whiteColor];
    [teacherLable.layer setCornerRadius:5.0 * KWIDTH_IPHONE6_SCALE];
    [teacherLable.layer setMasksToBounds:YES];
    teacherLable.backgroundColor = NORMAL_COLOR;
    [self.view addSubview:teacherLable];
    [teacherLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(classLabel.mas_bottom).offset(16*KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(classLabel);
        make.right.equalTo(classLabel);
        make.height.mas_equalTo(30*KWIDTH_IPHONE6_SCALE);
        
    }];
    [teacherLable whenTapped:^{
        JJMyTeacherViewController *myTeacherVC = [[JJMyTeacherViewController alloc]init];
        [weakSelf.navigationController pushViewController:myTeacherVC animated:YES];
    }];
    
    //账号安全
    UILabel *accountLable = [[UILabel alloc]init];
    accountLable .font = [UIFont boldSystemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
    accountLable.text = @"账号安全";
    accountLable.textColor = [UIColor whiteColor];
    [accountLable.layer setCornerRadius:5.0 * KWIDTH_IPHONE6_SCALE];
    [accountLable.layer setMasksToBounds:YES];
    accountLable.backgroundColor = NORMAL_COLOR;
    [self.view addSubview:accountLable];
    [accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(teacherLable.mas_bottom).offset(16*KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(teacherLable);
        make.right.equalTo(teacherLable);
        make.height.mas_equalTo(30*KWIDTH_IPHONE6_SCALE);
    }];
    [accountLable whenTapped:^{
        JJAccountSecurityViewController *accountScurityVC = [[JJAccountSecurityViewController alloc]init];
        [weakSelf.navigationController pushViewController:accountScurityVC animated:YES];
    }];
    
}

//设置背景图
- (void)setBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}
//设置导航条
- (void)setNavigationBar {
    self.titleName = @"个人信息";
}

//接收通知
- (void)addNotificateWithRefresh {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestWithPersonalMessage) name:EditInfoSuccessNotification object:nil];
}


#pragma mark - 进入编辑个人信息界面
- (void)pushEdirVC {
    JJEditPersonalMessageViewController *editVC = [[JJEditPersonalMessageViewController alloc]init];
//    weakSelf(weakSelf);
//    editVC.editInfoSuccessBlock = ^{
//        [weakSelf requestWithPersonalMessage];
//    };
    [self.navigationController pushViewController:editVC animated:YES];
}


//左端按钮点击事件
- (void)leftBarButtonClick {
    if(self.fd_interactivePopDisabled) {
        //如果是不可左划的,说明是自学用户
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:POP object:@0];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
        
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    //    });
    
    //    [self dismissViewControllerAnimated:NO completion:^{
    //            }];
    
}

#pragma mark - 个人信息请求
- (void)requestWithPersonalMessage {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_STUDENT_INFO];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
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
        NSDictionary *student_info = response[@"student_info"];
        User *user = [User getUserInformation];
        user.sex = student_info[@"gender"];
        user.birthday = student_info[@"birthday"];
        user.avatar_url = student_info[@"avatar"];
        user.user_nicename = student_info[@"nicename"];
        user.user_code = student_info[@"user_code"];
        user.school_name = student_info[@"school_name"];
        user.class_name = student_info[@"class_name"];
        [User saveUserInformation:user];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar_url]placeholderImage:[UIImage imageNamed:@"icon_image_new"]];
        self.nameLabel.text = [NSString stringWithFormat:@" %@ ",user.user_nicename];
        self.stuLabel.text = [NSString stringWithFormat: @"  学号:%@  ",user.user_code];
        self.classLabel.text = [NSString stringWithFormat:@"班级: %@",user.class_name];
      
        DebugLog(@"%@",user.sex.class);
        
        
        if([user.sex isKindOfClass:[NSNumber class]]) {
            if(user.sex.integerValue == 1) {
                //男
                self.sexImageV.image = [UIImage imageNamed:@"editBoyicon"];
            } else if(user.sex.integerValue == 2) {
                //女
                self.sexImageV.image = [UIImage imageNamed:@"editGirlicon"];
            } else {
                //不知道性别
                self.sexImageV.image = [UIImage imageNamed:@""];
            }

        }
        
        NSString *text =[NSString stringWithFormat: @"所在学校：%@",user.school_name];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.headIndent = 94*KWIDTH_IPHONE6_SCALE;
        paragraphStyle.firstLineHeadIndent = -94*KWIDTH_IPHONE6_SCALE;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        self.schoolLabel.attributedText = attributedString;

    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];

}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

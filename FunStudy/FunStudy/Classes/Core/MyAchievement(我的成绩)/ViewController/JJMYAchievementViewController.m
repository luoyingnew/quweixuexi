//
//  JJMYAchievementViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMYAchievementViewController.h"
#import "JJMyAchievementCenterBtn.h"
#import "JJSettingViewController.h"
#import "JJTeacherAwardViewController.h"
#import "JJReportCartViewController.h"
//#import "JJSearchTeacherViewController.h"
#import "UILabel+LabelStyle.h"
#import "PersonMessageViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface JJMYAchievementViewController ()

//超过同学
@property (nonatomic, strong)JJMyAchievementCenterBtn *exceedStudentBtn;
//完成题数
@property (nonatomic, strong)JJMyAchievementCenterBtn *overHomerWorkBtn;
//作业完成
@property (nonatomic, strong)JJMyAchievementCenterBtn *successOverHomeworkBtn;
//本月还没有做过作业
@property (nonatomic, strong) UILabel *tipLabel;

//这个task是每次进入该界面的轮播task,目的:当多次频繁进入该界面时,如果上一个请求还没有完成,新的不要做
@property (nonatomic, strong) HFURLSessionTask *homeworkTask;
//作业题task
@property (nonatomic, strong) HFURLSessionTask *myReportDataTask;

@end

@implementation JJMYAchievementViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![User getUserInformation].user_class) {
        PersonMessageViewController *personMessageViewController = [[PersonMessageViewController alloc]init];
        personMessageViewController.fd_interactivePopDisabled = YES;
        [self.navigationController pushViewController:personMessageViewController animated:NO];
        //老师是否已经同意加入班级
        [self requestTheHomeWork];
    } else {
        [self requestWithMyReportData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseView];
    [self setNavigationBar];
    
}

//设置背景图
- (void)setBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"FunClassBackImage"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    UIImageView *centerBackImageView1 = [[UIImageView alloc]init];
    centerBackImageView1.image = [UIImage imageNamed:@"FunClassCenterImage1"];
    centerBackImageView1.userInteractionEnabled = YES;
    [self.view addSubview:centerBackImageView1];
    [centerBackImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(104 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
    }];
    UIImageView *centerBackImageView2 = [[UIImageView alloc]init];
    [centerBackImageView2 createBordersWithColor:[UIColor clearColor] withCornerRadius:10 andWidth:0];
    centerBackImageView2.userInteractionEnabled = YES;
    centerBackImageView2.backgroundColor = RGBA(170, 239, 250, 1);
//    centerBackImageView2.image = [UIImage imageNamed:@"FunClassCenterImage2"];
    [centerBackImageView1 addSubview:centerBackImageView2];
    [centerBackImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(295 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(230 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //提示做过作业label
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.font = [UIFont boldSystemFontOfSize:21 * KWIDTH_IPHONE6_SCALE];
    tipLabel.textColor = RGBA(78, 125, 213, 1);
    tipLabel.text = @"本月还没有做过作业";
    self.tipLabel = tipLabel;
    [centerBackImageView2 addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(27 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView2);
    }];
    
    //超过同学
    JJMyAchievementCenterBtn *exceedStudentBtn = [[JJMyAchievementCenterBtn alloc]init];
    self.exceedStudentBtn = exceedStudentBtn;
    exceedStudentBtn.topTitle.text = @"0";
    exceedStudentBtn.bottomTitle.text = @"超过同学";
    [centerBackImageView2 addSubview:exceedStudentBtn];
    [exceedStudentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(72 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(53 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(17 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(87 * KWIDTH_IPHONE6_SCALE);
    }];
    //完成题数
    JJMyAchievementCenterBtn *overHomerWorkBtn = [[JJMyAchievementCenterBtn alloc]init];
    self.overHomerWorkBtn = overHomerWorkBtn;
    overHomerWorkBtn.topTitle.text = @"0";
    overHomerWorkBtn.bottomTitle.text = @"完成题数";
    [centerBackImageView2 addSubview:overHomerWorkBtn];
    [overHomerWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(72 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(53 * KWIDTH_IPHONE6_SCALE);
//        make.left.with.offset(17 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(87 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView2);
    }];

    //作业完成
    JJMyAchievementCenterBtn *successOverHomeworkBtn = [[JJMyAchievementCenterBtn alloc]init];
    self.successOverHomeworkBtn = successOverHomeworkBtn;
    successOverHomeworkBtn.topTitle.text = @"0";
    successOverHomeworkBtn.bottomTitle.text = @"作业完成";
    [centerBackImageView2 addSubview:successOverHomeworkBtn];
    [successOverHomeworkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(72 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(53 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-17 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(87 * KWIDTH_IPHONE6_SCALE);
    }];

    //我的作业报告
    UIButton *myHomeWorkReportBtn = [[UIButton alloc]init];
    [myHomeWorkReportBtn addTarget:self action:@selector(PushToReportCartVC) forControlEvents:UIControlEventTouchUpInside];
    [myHomeWorkReportBtn setBackgroundImage:[UIImage imageNamed:@"MyHomeworkReport"] forState:UIControlStateNormal];
    
    myHomeWorkReportBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
    [centerBackImageView2 addSubview:myHomeWorkReportBtn];
    [myHomeWorkReportBtn setTitle:@"我的作业报告" forState:UIControlStateNormal];
    [myHomeWorkReportBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [myHomeWorkReportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView2);
        make.bottom.with.offset(-22 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(181 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(33 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //老师奖励按钮
    UIButton *teacherRewardBtn = [[UIButton alloc]init];
    [teacherRewardBtn addTarget:self action:@selector(pushToTeachAwardVC) forControlEvents:UIControlEventTouchUpInside];
    [teacherRewardBtn setBackgroundColor:RGBA(78, 125, 213, 1)];
    [teacherRewardBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:8 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [centerBackImageView1 addSubview:teacherRewardBtn];
    [teacherRewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerBackImageView2.mas_bottom).with.offset(8 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(21 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(27 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(213 * KWIDTH_IPHONE6_SCALE);
    }];
    UILabel *teachBtnLabel1 = [[UILabel alloc]init];
    teachBtnLabel1.textColor = [UIColor whiteColor];
    teachBtnLabel1.text = @"老师奖励";
    teachBtnLabel1.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
    [teacherRewardBtn addSubview:teachBtnLabel1];
    [teachBtnLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(teacherRewardBtn);
        make.left.with.offset(13 * KWIDTH_IPHONE6_SCALE);
    }];
    UILabel *teachBtnLabel2 = [[UILabel alloc]init];
    teachBtnLabel2.textColor = [UIColor whiteColor];
    teachBtnLabel2.text = @">";
    teachBtnLabel2.font = [UIFont boldSystemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
    [teacherRewardBtn addSubview:teachBtnLabel2];
    [teachBtnLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(teacherRewardBtn);
        make.right.with.offset(-7 * KWIDTH_IPHONE6_SCALE);
    }];

}


//设置navigationbar
- (void)setNavigationBar {
    self.navigationViewBg.hidden = YES;
    //设置按钮
    UIButton *settingBtn = [[UIButton alloc]init];
    [self.view addSubview:settingBtn];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"FunClassRule"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(gotoSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [settingBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
    [settingBtn setTitleColor:RGBA(148, 0, 0, 1) forState:UIControlStateNormal];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-25 * KWIDTH_IPHONE6_SCALE);
        make.width.with.offset(50 * KWIDTH_IPHONE6_SCALE);
        make.height.with.offset(25 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"个人中心";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
    if(isPhone) {
        [titleLabel headIndentLength:19 * KWIDTH_IPHONE6_SCALE];
    } else {
        [titleLabel headIndentLength:14 * KWIDTH_IPHONE6_SCALE];
    }
    
    //[titleLabel tailIndentLength:10];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:15 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [titleLabel setBackgroundColor:RGBA(78, 125, 213, 1)];
    
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(36 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(92 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(30 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
    }];
    UIImageView *titleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MyAchievementTitle"]];
    [self.view addSubview:titleImage];
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(42 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(38 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(titleLabel);
        make.centerX.equalTo(titleLabel.mas_left);
    }];
}



#pragma mark - request
#pragma mark 老师是否已经同意加入班级请求
- (void)requestTheHomeWork {
    if (![Util isNetWorkEnable]) {
        return;
    }
    
    //self.homeworkTast任务正在跑,那就直接返回,不再做一次多余的访问请求
    if(self.homeworkTask != nil && self.homeworkTask.state == NSURLSessionTaskStateRunning) {
        return;
    }
    //    [JJHud showStatus:nil];
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_CAROUSEL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[User getUserInformation].fun_user_id forKey:@"user_id"];
    self.homeworkTask = [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        //        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            return ;
        }
        User *currentUser = [User getUserInformation];
        User *user = [User mj_objectWithKeyValues:response];
        currentUser.user_class = user.user_class;
        [User saveUserInformation:currentUser];
        //如果有班级
        if(user.user_class) {
            //发出通知让首页和tabbar修改
            [[NSNotificationCenter defaultCenter]postNotificationName:SuccessJoinClass object:nil];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    } fail:^(NSError *error) {
    }];
    
}

#pragma mark 我的成绩数据请求
- (void)requestWithMyReportData {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    //self.homeworkTast任务正在跑,那就直接返回,不再做一次多余的访问请求
    if(self.myReportDataTask != nil && self.myReportDataTask.state == NSURLSessionTaskStateRunning) {
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_GRADE];
//    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
//    [JJHud showStatus:nil];
    self.myReportDataTask = [HFNetWork getWithURL:URL params:nil isCache:NO success:^(id response) {
//        [JJHud dismiss];
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
//            [JJHud showToast:codeMessage];
            return ;
        }
        //超过同学
        self.exceedStudentBtn.topTitle.text = [response[@"data"][@"exceed"] stringValue];
        //完成题数
        self.overHomerWorkBtn.topTitle.text = [response[@"data"][@"item_finish"] stringValue];
        //作业完成
        self.successOverHomeworkBtn.topTitle.text =[NSString stringWithFormat:@"%@/%@",response[@"data"][@"done_homework"], response[@"data"][@"count_homework"]];
        if([response[@"data"][@"done_homework"] intValue] != 0) {
            self.tipLabel.hidden = YES;
        }
       
    } fail:^(NSError *error) {
//        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - 前往作业报告成绩单页面
- (void)PushToReportCartVC {
    JJReportCartViewController *reportCartVC = [[JJReportCartViewController alloc]init];
    [self.navigationController pushViewController:reportCartVC animated:YES];
}
#pragma mark - 前往老师奖励界面
- (void)pushToTeachAwardVC {
    JJTeacherAwardViewController *teachAwardVC = [[JJTeacherAwardViewController alloc]init];
    [self.navigationController pushViewController:teachAwardVC animated:YES];
}

#pragma mark - 前往设置界面
- (void)gotoSettingVC {
    JJSettingViewController *settingVC = [[JJSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end

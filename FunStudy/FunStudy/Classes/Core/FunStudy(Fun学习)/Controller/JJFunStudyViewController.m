//
//  JJFunStudyViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunStudyViewController.h"
#import <ReactiveCocoa.h>
#import "JJMyCoinViewController.h"
#import "JJFunClassRoomViewController.h"
#import "JJFunAlerView.h"
#import "JJMessageViewController.h"
#import "JJFunTrackViewController.h"
#import "JJBilingualViewController.h"
#import "JJSingleChooseViewController.h"
#import "JJTransLateViewController.h"
#import "JJErrorCorrectionViewController.h"
#import "JJListeningTestViewController.h"
#import "JJReadTestViewController.h"
#import "JJClozeProcedureViewController.h"
#import "JJHomeworkListViewController.h"
#import "JJFollowReadViewController.h"
#import "JJSettingViewController.h"
#import "UIViewController+Alert.h"
#import "JPUSHService.h"
#import "JJMessageButton.h"
#import <AVFoundation/AVFoundation.h>
#import "JJWordSpellingViewController.h"
#import "JJOverHomeWorkViewController.h"
#import "JJUnitViewController.h"
#import "JJTopicViewController.h"
#import "JJPlateViewController.h"
#import "JJSearchTeacherViewController.h"
#import "XZShare.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import "JJOverHomeWorkViewController.h"

//typedef NS_ENUM(NSInteger, StudyStype) {
//    FunNoStudent,//无
//    FunAddHomeWork,//补作业
//    FunNewTest,//最新测验
//    FunNewHomeWork,//最新作业
//};
//static int aaa;
@interface JJFunStudyViewController ()<UIActionSheetDelegate>

//当前选中的第几个作业
@property(nonatomic,assign)NSInteger currentIndex;

//右部消息按钮
@property (nonatomic, strong) JJMessageButton *rightMessageButton;

//作业状态按钮
@property (nonatomic, strong) UIButton *homeworkBookBtn;
//左边箭头按钮
@property (nonatomic, strong)UIButton *leftBtn;
//右边箭头按钮
@property (nonatomic, strong)UIButton *rightBtn;
//作业数组
@property (nonatomic, strong) NSMutableArray *homeWorkArray;
//Fun学足迹|自学中心
@property (nonatomic, strong) UIButton *funRightBtn;
//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//名字
@property (nonatomic, strong) UIButton *nameBtn;
//金币
@property (nonatomic, strong) UIButton *goldBtn;

//这个tast是每次进入该界面的轮播task,目的:当多次频繁进入该界面时,如果上一个请求还没有完成,新的不要做
@property (nonatomic, strong) HFURLSessionTask *homeworkTask;

////播放器
//@property(nonatomic, strong)AVPlayer *player;

//@property (nonatomic, strong) NSString *a;
//@property (nonatomic, strong) NSString *b;


@end

@implementation JJFunStudyViewController
//每次进入这个界面都做一次请求
- (void)viewWillAppear:(BOOL)animated {
    DebugLog(@"%@",NSStringFromCGRect(self.view.bounds));
//    if(![User getUserInformation].user_class) {
        [self requestTheHomeWork];
//    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    d[@"e"] = [[NSNull alloc]init];
    d[@"r"] = @"fds";
//    [d setRemovesKeysWithNullValues:YES];
    User *ui = [[User alloc]init];
    ui.sex = [[NSNull alloc]init];
    ui.sex.integerValue;
    
    
       //[RACSignal combineLatest:@[RACObserve(self, a),RACObserve(self, b)]];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    DebugLog(@"%@",session.category);
    
    DebugLog(@"%ld  %lf  %lf  %lf  %ld", [[UIDevice currentDevice] userInterfaceIdiom],KWIDTH_IPHONE6_SCALE,SCREEN_WIDTH / 375.0,SCREEN_HEIGHT / 667.0,isPhone);
    User *u = [User getUserInformation];
    [self setBaseView];
    [self setNavigationBar];
    [self setCenterView];
    [self setupBottomView];
//    self.funType = FunNewHomeWork;
//    if ([User getUserInformation].user_class) {
//        //如果有班级
//        //首页轮播
//        [self requestTheHomeWork];
//    } else {
//        //如果没有班级
//    }
    //添加通知   若自学用户加入班级成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successJoinClass) name:SuccessJoinClass object:nil];
    //添加通知   若用户资料发生改变,则做界面修改
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editInfoSuccess) name:EditInfoSuccessNotification object:nil];
    
    
    //发出通知让首页消息按钮的小红点状态改变.在这主要是当程序被杀死时,用户通过点击icon或点击推送消息进入时的情况
    if([UIApplication sharedApplication].applicationIconBadgeNumber) {
        [[NSNotificationCenter defaultCenter]postNotificationName:JpushMessageHideNotificatiion object:@(YES)];
    } else {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:JpushMessageHideNotificatiion object:@(NO)];
    }
}

#pragma mark 设置背景图
- (void)setBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"FunStudy_BackImage"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}

#pragma mark 设置导航条
- (void)setNavigationBar {
    
    //隐藏Navigationbar
    self.navigationViewBg.hidden = YES;
    
    //右端设置按钮
    UIButton *rightSettingButton = [[UIButton alloc]init];
    [rightSettingButton setBackgroundImage:[UIImage imageNamed:@"FunStudySetting"] forState:UIControlStateNormal];
    [rightSettingButton addTarget:self action:@selector(pushToSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightSettingButton];
    [rightSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(17 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-20 * KWIDTH_IPHONE6_SCALE);
        make.width.height.equalTo(@(40 * KWIDTH_IPHONE6_SCALE));
    }];
    //右部消息按钮
    JJMessageButton *rightMessageButton = [[JJMessageButton alloc]init];
    self.rightMessageButton = rightMessageButton;
    [rightMessageButton setBackgroundImage:[UIImage imageNamed:@"FunStudyMessage"] forState:UIControlStateNormal];
    [rightMessageButton addTarget:self action:@selector(pushToMessageVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightMessageButton];
    [rightMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(17 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(rightSettingButton.mas_left).with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        make.width.height.equalTo(@(40 * KWIDTH_IPHONE6_SCALE));
    }];
    //监听推送通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(acceptJpushMessageCountChange:) name:JpushMessageHideNotificatiion object:nil];
    
    

    //左端个人信息View
    UIView *leftView = [[UIView alloc]init];
    weakSelf(weakSelf);
//    JJSettingViewController *settingVC = [[JJSettingViewController alloc]init];
    [leftView whenTapped:^{
        [weakSelf pushToMyCoin];
    }];
    leftView.backgroundColor = [UIColor whiteColor];
    [leftView createBordersWithColor:RGBA(0, 142, 196, 1) withCornerRadius:6 andWidth:2];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(16 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(87 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(41 * KWIDTH_IPHONE6_SCALE);
    }];
    //头像
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_image_new"]];
    self.iconImageView = iconImageView;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[User getUserInformation].avatar_url] placeholderImage:[UIImage imageNamed:@"icon_image_new"]];
    [iconImageView createBordersWithColor:[UIColor clearColor] withCornerRadius:16.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [leftView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView);
        make.width.height.mas_equalTo(33 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(7 * KWIDTH_IPHONE6_SCALE);
    }];
    //名字
    UIButton *nameBtn = [[UIButton alloc]init];
    self.nameBtn = nameBtn;
    nameBtn.backgroundColor = NORMAL_COLOR;
    [nameBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:(6.5 * KWIDTH_IPHONE6_SCALE) andWidth:0];
    [nameBtn.titleLabel setFont:[UIFont systemFontOfSize:10 * KWIDTH_IPHONE6_SCALE]];
//    [nameBtn setTitle:@"姓名" forState:UIControlStateNormal];
    [nameBtn setTitle:[User getUserInformation].user_nicename forState:UIControlStateNormal];
    [leftView addSubview:nameBtn];
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).with.offset(3 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(leftView).with.offset(-7 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(leftView).with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(13 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
     //金币
    UIView *goldBackView = [[UIView alloc]init];
    [goldBackView createBordersWithColor:NORMAL_COLOR withCornerRadius:(6.5 * KWIDTH_IPHONE6_SCALE) andWidth:0];
    goldBackView.backgroundColor = NORMAL_COLOR;
    [leftView addSubview:goldBackView];
    [goldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).with.offset(3 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(leftView).with.offset(-7 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(leftView).with.offset(-5 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(13 * KWIDTH_IPHONE6_SCALE);
    }];
    UIImageView *goldImageV = [[UIImageView alloc]init];
    [goldBackView addSubview:goldImageV];
    [goldImageV setImage:[UIImage imageNamed:@"gold"]];
    [goldImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-3.5 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(goldBackView);
        make.width.height.mas_equalTo(10 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //金币
    UIButton *goldBtn = [[UIButton alloc]init];
    goldBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.goldBtn = goldBtn;
    [goldBtn addTarget:self action:@selector(pushToMyCoin) forControlEvents:UIControlEventTouchUpInside];
    [goldBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    //[goldBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:(6.5 * KWIDTH_IPHONE6_SCALE) andWidth:0];
    goldBtn.backgroundColor = [UIColor clearColor];
//    [goldBtn setTitle:@"100" forState:UIControlStateNormal];
//    User *user = self.user;
    [goldBtn setTitle:[NSString stringWithFormat:@"%ld",[User getUserInformation].user_coin] forState:UIControlStateNormal];
    [goldBtn.titleLabel setFont:[UIFont systemFontOfSize:10 * KWIDTH_IPHONE6_SCALE]];
    //[goldBtn setBackgroundImage:[UIImage imageNamed:@"gold"] forState:UIControlStateNormal];
//    goldBtn.imageView.backgroundColor = [UIColor greenColor];
//    [goldBtn horizontalCenterTitleAndImage:10];
    [goldBackView addSubview:goldBtn];
    [goldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goldBackView.mas_left).with.offset(3 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(goldImageV.mas_left).with.offset(-2 * KWIDTH_IPHONE6_SCALE);
        make.top.bottom.with.offset(0);
    }];
    //[goldBtn horizontalCenterTitleAndImage:2];
}

#pragma mark 设置中间视图
- (void)setCenterView {
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"FunStudyCenterImage"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(80 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(350 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(300 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //左端按钮 箭头
    UIButton *leftBtn = [[UIButton alloc]init];
    self.leftBtn = leftBtn;
    [self.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"FunStudyLeftBtn"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(12 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(223 * KWIDTH_IPHONE6_SCALE);
    }];
    //右端按钮 箭头
    UIButton *rightBtn = [[UIButton alloc]init];
    self.rightBtn = rightBtn;
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"FunStudyRightBtn"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-12 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(223 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //补作业 最新测验 最新作业
    UIButton *homeworkBook = [[UIButton alloc]init];
    self.homeworkBookBtn = homeworkBook;
    [self.homeworkBookBtn addTarget:self action:@selector(homeworkListBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    homeworkBook.backgroundColor = RGBA(0, 111, 38, 1);
    [homeworkBook setTitle:@"" forState:UIControlStateNormal];
    [homeworkBook.titleLabel setFont:[UIFont systemFontOfSize:19*KWIDTH_IPHONE6_SCALE]];
    [homeworkBook setTitleColor:RGBA(86, 208, 126, 1) forState:UIControlStateNormal];
    [homeworkBook createBordersWithColor:[UIColor clearColor] withCornerRadius:10 andWidth:0];
    [self.view addSubview:homeworkBook];
    [homeworkBook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(221 * KWIDTH_IPHONE6_SCALE);
        make.right.equalTo(rightBtn.mas_left).with.offset(-3 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(29 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(88 * KWIDTH_IPHONE6_SCALE);
    }];
    
//    if (self.homeWorkArray.count == 0) {
//        self.homeworkBookBtn.hidden = YES;
//        self.leftBtn.hidden = YES;
//        self.rightBtn.hidden = YES;
//    } else {
//        for(int i = 0 ; i < self.homeWorkArray.count ; i++) {
//            if(i == self.currentIndex) {
//                [self.homeworkBookBtn setTitle:self.homeWorkArray[i] forState:UIControlStateNormal];
//            }
//        }
//    }
    
//    //观察数组个数
//    [RACObserve(self, homeWorkArray.count) subscribeNext:^(id x) {
//        
//    }];;
//    [RACObserve(self.homeWorkArray, count) subscribeNext:^(NSNumber *count) {
////        @strongify(self);
//        NSInteger arrayCount = count.integerValue;
//        if (arrayCount == 0) {
//            self.leftBtn.hidden = YES;
//            self.rightBtn.hidden = YES;
//            self.homeworkBookBtn.hidden = YES;
//        }else if (arrayCount == 1) {
//            self.leftBtn.hidden = YES;
//            self.rightBtn.hidden = YES;
//        }
//    }];
    
    //RAC观察状态的变化
    //观察当前选中的
    @weakify(self);
    [RACObserve(self, currentIndex) subscribeNext:^(NSNumber *number) {
        @strongify(self);
        if(self.homeWorkArray.count == 0) {
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.homeworkBookBtn.hidden = YES;
            return;
        }
        self.homeworkBookBtn.hidden = NO;
        NSInteger currentIndex = number.integerValue;
        [self.homeworkBookBtn setTitle:self.homeWorkArray[currentIndex] forState:UIControlStateNormal];
        if(currentIndex == 0) {
            self.leftBtn.hidden = YES;
        } else {
            self.leftBtn.hidden = NO;
        }
        if(currentIndex == self.homeWorkArray.count-1) {
            self.rightBtn.hidden = YES;
        } else {
            self.rightBtn.hidden = NO;
        }
//        if(!(currentIndex == 0 || currentIndex == self.homeWorkArray.count-1)) {
//            self.leftBtn.hidden = NO;
//            self.rightBtn.hidden = NO;
//        }
    }];
}

#pragma mark 设置底部视图
- (void)setupBottomView {
    //左端按钮  Fun课堂
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn addTarget:self action:@selector(pushToFunClassRoomVC) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"FunStudy_ClassRoom"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(144 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(89 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(35 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(385 * KWIDTH_IPHONE6_SCALE);
    }];
    //右端按钮  自学中心||Fun学足迹
    UIButton *rightBtn = [[UIButton alloc]init];
    self.funRightBtn = rightBtn;
    [self.funRightBtn addTarget:self action:@selector(pushToFunTrackVC) forControlEvents:UIControlEventTouchUpInside];
    if([User getUserInformation].user_class) {
        //如果是已加入班级用户
        [self.funRightBtn setBackgroundImage:[UIImage imageNamed:@"FunTrack"] forState:UIControlStateNormal];
    } else {
        //如果是自学用户
         [rightBtn setBackgroundImage:[UIImage imageNamed:@"FunStudy_Clock"] forState:UIControlStateNormal];
    }
   
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(144 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(89 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-35 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(385 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 推送通知,未读消息按钮小红点状态需要改变
- (void)acceptJpushMessageCountChange:(NSNotification *)noti {
    if([noti.object boolValue]) {
        //有红点
        self.rightMessageButton.isHideTip = NO;
    } else {
        //无红点
        self.rightMessageButton.isHideTip = YES;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
    }
//    self.rightMessageButton.isHideTip = !messageCount;
}

#pragma mark - 用户资料发生改变
- (void)editInfoSuccess {
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_STUDENT_INFO];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
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
        [self.nameBtn setTitle:[User getUserInformation].user_nicename forState:UIControlStateNormal];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[User getUserInformation].avatar_url] placeholderImage:[UIImage imageNamed:@"icon_image_new"]];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}



//自学用户加入班级成功
- (void)successJoinClass {
    if([User getUserInformation].user_class) {
        //如果是已加入班级用户
        [self.funRightBtn setBackgroundImage:[UIImage imageNamed:@"FunTrack"] forState:UIControlStateNormal];
    } else {
        //如果是自学用户
        [self.funRightBtn setBackgroundImage:[UIImage imageNamed:@"FunStudy_Clock"] forState:UIControlStateNormal];
    }
}

//是否有新作业  首页轮播
- (void)requestTheHomeWork {
    if (![Util isNetWorkEnable]) {
        //        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    //self.homeworkTast任务正在跑,那就直接返回,不再做一次多余的访问请求
    if(self.homeworkTask != nil && self.homeworkTask.state == NSURLSessionTaskStateRunning) {
        return;
    }
    DebugLog(@"====%ld",self.homeworkTask.state);
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
//            [JJHud showToast:codeMessage];
            return ;
        }
//        NSMutableDictionary *d = [NSMutableDictionary dictionary];
//        d[@"new_homework"] = @1;
//        d[@"wait_homework"] = @1;
//        d[@"new_test"] = @1;
        User *currentUser = [User getUserInformation];
        User *user = [User mj_objectWithKeyValues:response];
        currentUser.user_coin = user.user_coin;
        currentUser.last_new_testID = user.last_new_testID;
        currentUser.last_new_test_title = user.last_new_test_title;
        currentUser.last_new_homeworkID = user.last_new_homeworkID;
        currentUser.last_new_homework_title = user.last_new_homework_title;
        currentUser.class_type = user.class_type;
//        currentUser.new_test = user.new_test;
//        currentUser.new_homework = user.new_homework;
//        currentUser.wait_homework = user.wait_homework;
        [User saveUserInformation:currentUser];
        [self.goldBtn setTitle:[NSString stringWithFormat:@"%ld",[User getUserInformation].user_coin] forState:UIControlStateNormal];
        currentUser.class_type = user.class_type;
        //如果有班级
        if(currentUser.user_class != user.user_class && user.user_class) {
            currentUser.user_class = user.user_class;
            [User saveUserInformation:currentUser];
            //发出通知让首页和tabbar修改
            [[NSNotificationCenter defaultCenter]postNotificationName:SuccessJoinClass object:nil];
        }
        if(!user.user_class) {
            //如果没有加入班级
            return;
        }
        //如果是否有最新作业,最新测验,补作业都一样 ,那就没有必要改变UI布局
        if((currentUser.new_test == user.new_test) && (currentUser.new_homework == user.new_homework) && (currentUser.wait_homework == user.wait_homework)) {
            return;
        } else {
            currentUser.new_test = user.new_test;
            currentUser.new_homework = user.new_homework;
            currentUser.wait_homework = user.wait_homework;
            [User saveUserInformation:currentUser];
            User *u = [User getUserInformation];
            if(currentUser.new_test && ![self.homeWorkArray containsObject:@"最新测验"]) {
                [self.homeWorkArray addObject:@"最新测验"];
            } else if(!currentUser.new_test){
                [self.homeWorkArray removeObject:@"最新测验"];
            }
            //最新作业
            if(currentUser.new_homework && ![self.homeWorkArray containsObject:@"最新作业"]) {
                [self.homeWorkArray addObject:@"最新作业"];
            } else if(!currentUser.new_homework) {
                [self.homeWorkArray removeObject:@"最新作业"];
            }
            //补作业
            if(currentUser.wait_homework && ![self.homeWorkArray containsObject:@"补作业"]) {
                [self.homeWorkArray addObject:@"补作业"];
            } else if(!currentUser.wait_homework) {
                [self.homeWorkArray removeObject:@"补作业"];
            }
            if(self.homeWorkArray.count) {
                NSMutableArray *homeMutableArray = [NSMutableArray array];
                for(NSString *name in self.homeWorkArray) {
                    if([name isEqualToString:@"最新作业"] && ![homeMutableArray containsObject:@"最新作业"]) {
                        [homeMutableArray addObject:@"最新作业"];
                    }
                }
                for(NSString *name in self.homeWorkArray) {
                    if([name isEqualToString:@"最新测验"] && ![homeMutableArray containsObject:@"最新测验"]) {
                        [homeMutableArray addObject:@"最新测验"];
                    }
                }
                for(NSString *name in self.homeWorkArray) {
                    if([name isEqualToString:@"补作业"] && ![homeMutableArray containsObject:@"补作业"]) {
                        [homeMutableArray addObject:@"补作业"];
                    }
                }
                self.homeWorkArray = homeMutableArray;
                self.currentIndex = 0;
            } else {
                self.currentIndex = -1;
            }
        }
        
    } fail:^(NSError *error) {
//        [JJHud showToast:@"加载失败"];
        DebugLog(@"shibai");
    }];
    DebugLog(@"tastzhuangtai%ld",self.homeworkTask.state);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DebugLog(@"tastzhuangtai%ld",self.homeworkTask.state);
    });
}

#pragma mark - 进去最新作业,最新测验,补作业
- (void)homeworkListBtnClick:(UIButton *)btn {
    weakSelf(weakSelf);
    if(![btn.titleLabel.text isEqualToString:@""]) {
        if([User getUserInformation].class_type == 1) {
            //小学
            if([btn.titleLabel.text isEqualToString: @"最新作业"]) {
                //小学最新作业
                JJPlateViewController *plateVC = [[JJPlateViewController alloc]init];
                plateVC.name = [User getUserInformation].last_new_homework_title;
                plateVC.typeName = @"最新作业";
                plateVC.homework_id = [User getUserInformation].last_new_homeworkID;
                [self.navigationController pushViewController:plateVC animated:YES];
            }
            if([btn.titleLabel.text isEqualToString: @"最新测验"]) {
                //小学最新测验
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新测验";//[User getUserInformation].last_new_test_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = [User getUserInformation].last_new_testID;
                homeworkModel.homework_title = [User getUserInformation].last_new_test_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
            if([btn.titleLabel.text isEqualToString: @"补作业"]) {
                //小学最补作业
                JJUnitViewController *unitVC = [[JJUnitViewController alloc]init];
                [self.navigationController pushViewController:unitVC animated:YES];
            }
        } else {
            //初中
            if([btn.titleLabel.text isEqualToString: @"最新作业"]) {
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新作业";//[User getUserInformation].last_new_homework_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = [User getUserInformation].last_new_homeworkID;
                homeworkModel.homework_title = [User getUserInformation].last_new_homework_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
            if([btn.titleLabel.text isEqualToString: @"最新测验"]) {
                //初中最新测验
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新测验";//[User getUserInformation].last_new_test_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = [User getUserInformation].last_new_testID;
                homeworkModel.homework_title = [User getUserInformation].last_new_test_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
            if([btn.titleLabel.text isEqualToString: @"补作业"]) {
                JJHomeworkListViewController *homeWorkListVC = [[JJHomeworkListViewController alloc]init];
                homeWorkListVC.name = btn.titleLabel.text;
                [self.navigationController pushViewController:homeWorkListVC animated:YES];
            }
        }
        
    }
}

#pragma mark - 前往Fun课堂按钮点击
- (void)pushToFunClassRoomVC {
    JJFunClassRoomViewController *classRoomVC = [[JJFunClassRoomViewController alloc]init];
//    classRoomVC.navigationTitleName = @"Fun课堂";
    [self.navigationController pushViewController:classRoomVC animated:YES];
}
#pragma mark - 前往Fun学足迹按钮点击    前往个人中心按钮点击
- (void)pushToFunTrackVC {
    if([User getUserInformation].user_class) {
        //如果是正常学生
        JJFunTrackViewController *funTrackVC = [[JJFunTrackViewController alloc]init];
        [self.navigationController pushViewController:funTrackVC animated:YES];
    } else {
        //如果是自学用户
        JJFunClassRoomViewController *classRoomVC = [[JJFunClassRoomViewController alloc]init];
//        classRoomVC.navigationTitleName = @"自学中心";
        classRoomVC.isSelfStudy = YES;
        [self.navigationController pushViewController:classRoomVC animated:YES];
    }
}

#pragma mark - 进入我的学币
- (void)pushToMyCoin {
    JJMyCoinViewController *myCoinVC = [[JJMyCoinViewController alloc]init];
    [self.navigationController pushViewController:myCoinVC animated:YES];
}

#pragma mark - 前往消息页面
- (void)pushToMessageVC {
    if(![User getUserInformation].user_class) {
        //        如果还未加入班级 则进入找到老师界面
        JJSearchTeacherViewController *searchTeacherVC = [[JJSearchTeacherViewController alloc]init];
        [self.navigationController pushViewController:searchTeacherVC animated:YES];
    } else {
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//        [JPUSHService setBadge:0];
        //发出通知让首页消息按钮的小红点状态改变
        [[NSNotificationCenter defaultCenter]postNotificationName:JpushMessageHideNotificatiion object:@(NO)];
        JJMessageViewController *messageVC = [[JJMessageViewController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
    
   
}
#pragma mark - 前往设置页面
- (void)pushToSettingVC {
    JJSettingViewController *settingVC = [[JJSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - 左端箭头按钮点击
-(void)leftBtnClick {
    self.currentIndex--;
}

#pragma mark 右端箭头按钮点击
- (void)rightBtnClick {
    self.currentIndex++;
}

#pragma mark 懒加载
- (NSMutableArray *)homeWorkArray {
    if(!_homeWorkArray) {
        _homeWorkArray = [NSMutableArray array];
    }
    return _homeWorkArray;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.navigationController pushViewController:[JJOverHomeWorkViewController new] animated:YES];
//    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
//    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        //        NSLog(@"%@ ",self.name);
//        [shareParams SSDKSetupShareParamsByText:@"我刚在Fun学APP完成了英语作业,成绩10分,你来也试试吧!"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:[NSString stringWithFormat:ShanreUrl]]
//                                          title:@"Fun学"
//                                           type:SSDKContentTypeAuto];
//        //        // 定制新浪微博的分享内容
//        //        [shareParams SSDKSetupSinaWeiboShareParamsByText:@"定制新浪微博的分享内容" title:self.model.name image:self.model.picture url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
//        //         //定制微信好友的分享内容
//        //        [shareParams SSDKSetupWeChatParamsByText:@"定制微信的分享内容" title:self.model.name url:[NSURL URLWithString:@"http://mob.com"] thumbImage:nil image:self.model.picture musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
//        //        [shareParams SSDKSetupQQParamsByText:@"定制QQ分享内容" title:self.model.name url:nil thumbImage:nil image:self.model.picture type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];//QQ好友
//        
//        
//        //有的平台要客户端分享需要加此方法，例如微博.不加这一句的话微博分享会不跳进微博页就分享成功
//        [shareParams SSDKEnableUseClientShare];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        SSUIShareActionSheetController *shareActionSheetController = [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               [JJHud showToast:@"分享成功"];
////                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
////                                                                                   message:nil
////                                                                                  delegate:nil
////                                                                         cancelButtonTitle:@"确定"
////                                                                         otherButtonTitles:nil];
////                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               if (error.code == 208) {
//                                   [JJHud showToast:@"未安装客户端"];
//                               } else {
//                                   [JJHud showToast:@"分享失败"];
//                               }
////                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
////                                                                               message:[NSString stringWithFormat:@"%@",error]
////                                                                              delegate:nil
////                                                                     cancelButtonTitle:@"OK"
////                                                                     otherButtonTitles:nil, nil];
////                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];
//        //加上这个可以不进UI编辑页面
//        [shareActionSheetController.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
//    }
//    
//
//    
//    
////    XZShare *share = [XZShare sharedInstance];
////    [share shareWithTitle:@"fdsfs" images:@[[UIImage imageNamed:@"FunClassRoomVideoBtn"]] content:@"邀你来参加EIGHTEEN的活动。" url:ShanreUrl];
//}
@end

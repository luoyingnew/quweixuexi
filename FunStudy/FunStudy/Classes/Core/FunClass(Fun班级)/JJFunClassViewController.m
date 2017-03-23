//
//  JJFunClassViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunClassViewController.h"
#import "JJRuleViewController.h"
#import "JJRankTableViewCell.h"
#import "JJSearchTeacherViewController.h"
#import "JJNavigationController.h"
#import "JJWordSpellingViewController.h"
#import "JJWriteTestViewController.h"
#import "JJOverHomeWorkViewController.h"
#import "JJFunClassTopScorerRankViewController.h"
#import "JJFunClassInteligenceViewController.h"


@interface JJFunClassViewController ()<UITableViewDataSource,UITableViewDelegate>

//当前scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
//当前选中的按钮
@property (nonatomic, weak) UIButton *currentSelectedBtn;
//状元按钮
@property (nonatomic, strong)UIButton *topScorerBtn;
//智慧按钮
@property (nonatomic, strong)UIButton *intelligenceButton;

//这个task是每次进入该界面的轮播task,目的:当多次频繁进入该界面时,如果上一个请求还没有完成,新的不要做
@property (nonatomic, strong) HFURLSessionTask *homeworkTask;

@end


@implementation JJFunClassViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DebugLog(@"jianyaojiangyaojingyao");
    User *u = [User getUserInformation];
    if(![User getUserInformation].user_class) {
//        如果还未加入班级
        JJSearchTeacherViewController *searchTeacherVC = [[JJSearchTeacherViewController alloc]init];
        [self.navigationController pushViewController:searchTeacherVC animated:NO];
        //老师是否已经同意加入班级
        [self requestTheHomeWork];
    }
}

#pragma mark - 老师是否已经同意加入班级Request
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseView];
    [self setNavigationBar];
    [self setupChildViewControllers];
    [self addChildVcView];
    self.currentSelectedBtn = self.intelligenceButton;
    self.currentSelectedBtn.selected = YES;
//    //写这个的目的是当是自学用户时会跳出一个加载黑框图
//    if ([User getUserInformation].user_class) {
//        //如果有班级
//        //状元榜访问
//        [self topScorerBtnClick:self.topScorerBtn];
//    } else {
//            //如果没有班级
//    }
}

//设置背景图
- (void)setBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"FunClassBackImage"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    backImageView.userInteractionEnabled = YES;
    
    UIImageView *centerBackImageView1 = [[UIImageView alloc]init];
    centerBackImageView1.userInteractionEnabled = YES;
    centerBackImageView1.image = [UIImage imageNamed:@"FunClassCenterImage1"];
    [self.view addSubview:centerBackImageView1];
    [centerBackImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(100 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(324 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(401 * KWIDTH_IPHONE6_SCALE);
    }];
    UIImageView *centerBackImageView2 = [[UIImageView alloc]init];
    centerBackImageView2.userInteractionEnabled = YES;
    centerBackImageView2.image = [UIImage imageNamed:@"FunClassCenterImage2"];
    [self.view addSubview:centerBackImageView2];
    [centerBackImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(66 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(290 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(400 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
        //智慧版Button
    UIButton *intelligenceButton = [[UIButton alloc]init];
    intelligenceButton.tag = 0;
    [intelligenceButton setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
    self.intelligenceButton = intelligenceButton;
    [intelligenceButton createBordersWithColor:[UIColor clearColor] withCornerRadius:15*KWIDTH_IPHONE6_SCALE andWidth:0];
     [intelligenceButton setBackgroundColor:RGBA(0, 143, 239, 1)];
    [intelligenceButton setTitle:@"智慧榜" forState:UIControlStateNormal];
    [intelligenceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:30 * KWIDTH_IPHONE6_SCALE]];
    [intelligenceButton addTarget:self action:@selector(funClassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [intelligenceButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [centerBackImageView2 addSubview:intelligenceButton];
    [intelligenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(97 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(55 * KWIDTH_IPHONE6_SCALE);
        //        make.top.with.offset(4 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(centerBackImageView2.mas_top).with.offset(110 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(30 * KWIDTH_IPHONE6_SCALE);
       
    }];
    
    //状元榜Button
    UIButton *topScorerBtn = [[UIButton alloc]init];
    topScorerBtn.tag = 1;
    self.topScorerBtn = topScorerBtn;
    [topScorerBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:15 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [topScorerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
    [topScorerBtn setBackgroundColor:RGBA(0, 143, 239, 1)];
    [topScorerBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [topScorerBtn setTitle:@"状元榜" forState:UIControlStateNormal];
    [topScorerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:30 * KWIDTH_IPHONE6_SCALE]];
    [topScorerBtn addTarget:self action:@selector(funClassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [centerBackImageView2 addSubview:topScorerBtn];
    [topScorerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(97 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(55 * KWIDTH_IPHONE6_SCALE);
        //        make.top.with.offset(4 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(centerBackImageView2.mas_top).with.offset(110 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-30 * KWIDTH_IPHONE6_SCALE);
    }];

    
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
//    scrollView.backgroundColor = [UIColor greenColor];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(273 * KWIDTH_IPHONE6_SCALE * 2, 0);
    [centerBackImageView2 addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView2);
        make.width.mas_equalTo(273 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(282 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(113 * KWIDTH_IPHONE6_SCALE);
    }];

//    //tableView
//    UITableView *rankTabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.rankTabelView = rankTabelView;
//    [rankTabelView registerClass:[JJRankTableViewCell class] forCellReuseIdentifier:rankTableViewCellIdentifier];
//    rankTabelView.backgroundColor = [UIColor clearColor];
//    rankTabelView.dataSource = self;
//    rankTabelView.delegate = self;
//    [centerBackImageView2 addSubview:rankTabelView];
//    [rankTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(centerBackImageView2);
//        make.top.with.offset(113 * KWIDTH_IPHONE6_SCALE);
//        make.width.mas_equalTo(273 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(282 * KWIDTH_IPHONE6_SCALE);
//    }];
}


//设置navigationbar
- (void)setNavigationBar {
    self.navigationViewBg.hidden = YES;
    //规则按钮
    UIButton *ruleBtn = [[UIButton alloc]init];
    [self.view addSubview:ruleBtn];
    [ruleBtn setBackgroundImage:[UIImage imageNamed:@"FunClassRule"] forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(gotoRuleVC) forControlEvents:UIControlEventTouchUpInside];
    [ruleBtn setTitle:@"规则" forState:UIControlStateNormal];
    [ruleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
    [ruleBtn setTitleColor:RGBA(148, 0, 0, 1) forState:UIControlStateNormal];
    [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-25 * KWIDTH_IPHONE6_SCALE);
        make.width.with.offset(52 * KWIDTH_IPHONE6_SCALE);
        make.height.with.offset(33 * KWIDTH_IPHONE6_SCALE);
    }];
}

//创建控制器
- (void)setupChildViewControllers {
    
    
    JJFunClassInteligenceViewController *funClassInteligenceViewController = [[JJFunClassInteligenceViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:funClassInteligenceViewController];
    JJFunClassTopScorerRankViewController *funClassTopScorerRankViewController = [[JJFunClassTopScorerRankViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:funClassTopScorerRankViewController];
}

#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    [self.view layoutIfNeeded];
    NSLog(@"%lf %lf",self.scrollView.contentOffset.x, self.scrollView.width);
    // 子控制器的索引
    NSUInteger index = (self.scrollView.contentOffset.x + self.scrollView.width / 2)/ self.scrollView.width;
    
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

//状元榜,智慧版按钮点击
- (void)funClassBtnClick:(UIButton *)titleButton {
    // 某个标题按钮被重复点击
    if (titleButton == self.currentSelectedBtn) {
        return;
    }
    // 控制按钮状态
    self.currentSelectedBtn.selected = NO;
    titleButton.selected = YES;
    self.currentSelectedBtn = titleButton;
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 选中\点击对应的按钮
    NSUInteger index = (scrollView.contentOffset.x + scrollView.width/2) / scrollView.width;
    UIButton *titleButton = nil;
    if(index == 0) {
        titleButton = self.intelligenceButton;
    } else {
        titleButton = self.topScorerBtn;
    }
    [self funClassBtnClick:titleButton];
    
    // 添加子控制器的view
    [self addChildVcView];
    
}


//前往规则页面
- (void)gotoRuleVC {
    JJRuleViewController *ruleVC = [[JJRuleViewController alloc]init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}


@end

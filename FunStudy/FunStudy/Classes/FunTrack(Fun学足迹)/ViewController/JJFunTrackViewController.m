//
//  JJFunTrackViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunTrackViewController.h"
#import "JJFunTrackHomeworkCell.h"
#import "JJFunTrackTestCell.h"
#import "UIView+JJTipNoData.h"
#import "JJFunScoreCommandViewController.h"
#import "JJHomeWorkDetailViewController.h"
#import "JJFunTrackHomeworkViewController.h"
#import "JJFunTrackTestViewController.h"
#import "JJMaskButton.h"


@interface JJFunTrackViewController ()<UITableViewDataSource,UITableViewDelegate>

//作业button
@property (nonatomic, strong) JJMaskButton *homeWorkBtn;
//测验button
@property (nonatomic, strong) JJMaskButton *testButton;
//当前选中的按钮
@property (nonatomic, weak) JJMaskButton *currentSelectedBtn;


//当前scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
//centerImageView
@property (nonatomic, strong) UIImageView *centerBackImageView;


@end


@implementation JJFunTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setupChildViewControllers];
    [self addChildVcView];
    self.currentSelectedBtn = self.homeWorkBtn;
    self.currentSelectedBtn.selected = YES;
}
#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"Fun学足迹";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    self.centerBackImageView = centerBackImageView;
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"Login_BackCenterImage"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(99 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //作业Button
    JJMaskButton *homeWorkBtn = [[JJMaskButton alloc]init];
    weakSelf(weakSelf);
    [homeWorkBtn whenTapped:^{
        DebugLog(@"点击了");
        [weakSelf homeWorkORTestBtnClick:weakSelf.homeWorkBtn];
    }];
//    [homeWorkBtn setBackgroundColor:[UIColor yellowColor]];
    
    homeWorkBtn.tag = 0;
    self.homeWorkBtn = homeWorkBtn;
    [homeWorkBtn setBackgroundImage:[UIImage imageNamed:@"FunTrackHomework"] forState:UIControlStateNormal];
    [homeWorkBtn setBackgroundImage:[UIImage imageNamed:@"FunTrackHomeworkSelected"] forState:UIControlStateSelected];
    //    [homeWorkBtn addTarget:self action:@selector(homeWorkORTestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [centerBackImageView addSubview:homeWorkBtn];
    [homeWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(97 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(55 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(4 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(42 * KWIDTH_IPHONE6_SCALE);
    }];
    //测验Button
    JJMaskButton *testButton = [[JJMaskButton alloc]init];
    testButton.tag = 1;
    self.testButton = testButton;
    [testButton whenTapped:^{
        DebugLog(@"点击了");
        [weakSelf homeWorkORTestBtnClick:weakSelf.testButton];
    }];
//    [testButton addTarget:self action:@selector(homeWorkORTestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [testButton setBackgroundImage:[UIImage imageNamed:@"FunTrackTest"] forState:UIControlStateNormal];
    [testButton setBackgroundImage:[UIImage imageNamed:@"FunTrackTestSelected"] forState:UIControlStateSelected];
    [centerBackImageView addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(97 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(55 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(4 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-42 * KWIDTH_IPHONE6_SCALE);
    }];

    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(291 * KWIDTH_IPHONE6_SCALE * 2, 0);
    [self.centerBackImageView addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(291 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(228 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(testButton.mas_bottom);
    }];

}

//创建控制器
- (void)setupChildViewControllers {
    JJFunTrackHomeworkViewController *funTrackHomeworkViewController = [[JJFunTrackHomeworkViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:funTrackHomeworkViewController];
    
    JJFunTrackTestViewController *funTrackTestViewController = [[JJFunTrackTestViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:funTrackTestViewController];
}

//作业||测试按钮点击
- (void)homeWorkORTestBtnClick:(UIButton *)titleButton {
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


#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    [self.view layoutIfNeeded];
    NSLog(@"%lf",self.scrollView.width);
    // 子控制器的索引
    NSUInteger index = (self.scrollView.contentOffset.x + self.scrollView.width/2) / self.scrollView.width;
    
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
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
        titleButton = self.homeWorkBtn;
    } else {
        titleButton = self.testButton;
    }
    [self homeWorkORTestBtnClick:titleButton];
    
    // 添加子控制器的view
    [self addChildVcView];
    
}


- (void)dealloc {
    DebugLog(@"销毁");
}
@end

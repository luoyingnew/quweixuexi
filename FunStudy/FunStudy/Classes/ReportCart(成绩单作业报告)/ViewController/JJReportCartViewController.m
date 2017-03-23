//
//  JJReportCartViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/16.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReportCartViewController.h"
#import "UIView+JJTipNoData.h"
#import "JJMaskButton.h"
#import "JJReportCartHomeworkViewController.h"
#import "JJReportCartTestViewController.h"
#import "JJHomeWorkDetailViewController.h"

@interface JJReportCartViewController ()

////作业button
//@property (nonatomic, strong) JJMaskButton *homeWorkBtn;
////测验button
//@property (nonatomic, strong) JJMaskButton *testButton;
////当前选中的按钮
//@property (nonatomic, weak) JJMaskButton *currentSelectedBtn;

//当前scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation JJReportCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setupChildViewControllers];
    [self addChildVcView];
//    self.currentSelectedBtn = self.homeWorkBtn;
//    self.currentSelectedBtn.selected = YES;

}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"成绩单";
    
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"TeacherAwardBack"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(315 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(99 * KWIDTH_IPHONE6_SCALE);
    }];
    
//    //作业Button
//    JJMaskButton *homeWorkBtn = [[JJMaskButton alloc]init];
//    weakSelf(weakSelf);
//    [homeWorkBtn whenTapped:^{
//        DebugLog(@"点击了");
//        [weakSelf homeWorkORTestBtnClick:weakSelf.homeWorkBtn];
//    }];
//    //    [homeWorkBtn setBackgroundColor:[UIColor yellowColor]];
//    
//    homeWorkBtn.tag = 0;
//    self.homeWorkBtn = homeWorkBtn;
//    [homeWorkBtn setBackgroundImage:[UIImage imageNamed:@"FunTrackHomework"] forState:UIControlStateNormal];
//    //    [homeWorkBtn addTarget:self action:@selector(homeWorkORTestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [centerBackImageView addSubview:homeWorkBtn];
//    [homeWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(97 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(55 * KWIDTH_IPHONE6_SCALE);
//        make.top.with.offset(4 * KWIDTH_IPHONE6_SCALE);
//        make.left.with.offset(42 * KWIDTH_IPHONE6_SCALE);
//    }];
//    //测验Button
//    JJMaskButton *testButton = [[JJMaskButton alloc]init];
//    testButton.tag = 1;
//    self.testButton = testButton;
//    [testButton whenTapped:^{
//        DebugLog(@"点击了");
//        [weakSelf homeWorkORTestBtnClick:weakSelf.testButton];
//    }];
//    //    [testButton addTarget:self action:@selector(homeWorkORTestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [testButton setBackgroundImage:[UIImage imageNamed:@"FunTrackTest"] forState:UIControlStateNormal];
//    [centerBackImageView addSubview:testButton];
//    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(97 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(55 * KWIDTH_IPHONE6_SCALE);
//        make.top.with.offset(4 * KWIDTH_IPHONE6_SCALE);
//        make.right.with.offset(-42 * KWIDTH_IPHONE6_SCALE);
//    }];

    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(0, 0);
//    scrollView.backgroundColor = [UIColor greenColor];
    [centerBackImageView addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(291 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(325 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(10 * KWIDTH_IPHONE6_SCALE);
    }];

}

//创建控制器
- (void)setupChildViewControllers {
    JJReportCartHomeworkViewController *reportCartHomeworkViewController = [[JJReportCartHomeworkViewController alloc]init];
    [self addChildViewController:reportCartHomeworkViewController];
    
    JJReportCartTestViewController *reportCartTestViewController = [[JJReportCartTestViewController alloc]init];
    [self addChildViewController:reportCartTestViewController];
}

////作业||测试按钮点击
//- (void)homeWorkORTestBtnClick:(UIButton *)titleButton {
//    // 某个标题按钮被重复点击
//    if (titleButton == self.currentSelectedBtn) {
//        return;
//    }
//    // 控制按钮状态
//    self.currentSelectedBtn.selected = NO;
//    titleButton.selected = YES;
//    self.currentSelectedBtn = titleButton;
//    // 让UIScrollView滚动到对应位置
//    CGPoint offset = self.scrollView.contentOffset;
//    offset.x = titleButton.tag * self.scrollView.width;
//    [self.scrollView setContentOffset:offset animated:YES];
//}


#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    [self.view layoutIfNeeded];
    NSLog(@"%lf",self.scrollView.width);
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

//#pragma mark - <UIScrollViewDelegate>
///**
// * 在scrollView滚动动画结束时, 就会调用这个方法
// * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
// */
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    [self addChildVcView];
//}
//
///**
// * 在scrollView滚动动画结束时, 就会调用这个方法
// * 前提: 人为拖拽scrollView产生的滚动动画
// */
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    // 选中\点击对应的按钮
//    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
//    UIButton *titleButton = nil;
//    if(index == 0) {
//        titleButton = self.homeWorkBtn;
//    } else {
//        titleButton = self.testButton;
//    }
//    [self homeWorkORTestBtnClick:titleButton];
//    
//    // 添加子控制器的view
//    [self addChildVcView];
//    
//}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    JJHomeWorkDetailViewController *homeWorkDetailViewController = [[JJHomeWorkDetailViewController alloc]init];
//    homeWorkDetailViewController.homework_id = @"800";
//    [self.navigationController pushViewController:homeWorkDetailViewController animated:YES];
//
//}

@end

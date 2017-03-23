//
//  JJBaseViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
//#import "JJBaseNavigationBar.h"

@interface JJBaseViewController ()

@end

@implementation JJBaseViewController
@synthesize navigationViewBg;
@synthesize navigationLeft;
@synthesize navigationRight;
@synthesize navigationTitle;


- (void)viewDidLoad {
    [super viewDidLoad];
    //创建导汗条
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
//    //加上左划手势
//    UIScreenEdgePanGestureRecognizer * screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(leftBarButtonClick)];
//    screenEdgePanGesture.edges = UIRectEdgeLeft;
//    [self.view addGestureRecognizer:screenEdgePanGesture];
    self.fd_prefersNavigationBarHidden = YES;
//    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = SCREEN_WIDTH / 2 ;
    
}

#pragma mark - 设置创建导航条及点击时间
- (void)setupNavigationBar {
//    self.navigationController.navigationBar.hidden = YES;
    //自定义导航背景
    navigationViewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_HEIGHT)];
    
    navigationViewBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navigationViewBg];
    //        [self.view bringSubviewToFront:navigationViewBg];
    
    //导航title
    UIView *navigationTitleView = [[UIView alloc]initWithFrame:CGRectMake(80 * KWIDTH_IPHONE6_SCALE, 0, SCREEN_WIDTH - 160 * KWIDTH_IPHONE6_SCALE, NAVIGATION_HEIGHT)];
    navigationTitleView.backgroundColor = [UIColor clearColor];
    [navigationViewBg addSubview:navigationTitleView];
    navigationTitle = [[UILabel alloc]init];//WithFrame:CGRectMake(80, 34, SCREEN_WIDTH - 160, 20)];
    [navigationTitleView addSubview:navigationTitle];
    [navigationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navigationTitleView);
        make.height.equalTo(@(34 * KWIDTH_IPHONE6_SCALE));
        make.top.with.offset(24 * KWIDTH_IPHONE6_SCALE);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH - (160 *KWIDTH_IPHONE6_SCALE)));
    }];
    navigationTitle.font = [UIFont boldSystemFontOfSize:25.0 * KWIDTH_IPHONE6_SCALE];//My_FontName(18.0f);
//    navigationTitle.textAlignment = NSTextAlignmentCenter;
    navigationTitle.textColor = [UIColor whiteColor];
    navigationTitle.backgroundColor = NORMAL_COLOR;
    [navigationTitle createBordersWithColor:[UIColor clearColor] withCornerRadius:14 andWidth:0];
    
    
    //导航左按钮
    navigationLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    
    navigationLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    navigationLeft.frame = CGRectMake(13 * KWIDTH_IPHONE6_SCALE, 7 * KWIDTH_IPHONE6_SCALE, 63 * KWIDTH_IPHONE6_SCALE, 49 * KWIDTH_IPHONE6_SCALE);
    navigationLeft.titleLabel.font = [UIFont systemFontOfSize:20 * KWIDTH_IPHONE6_SCALE];
    //My_FontName(12.0f);
    [navigationLeft setBackgroundImage:[UIImage imageNamed:@"NavigationBar_leftImage"] forState:UIControlStateNormal];
    [navigationLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationLeft addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationViewBg addSubview:navigationLeft];
    
//    //导航右按钮
//    navigationRight = [UIButton buttonWithType:UIButtonTypeCustom];
//    navigationRight.frame = CGRectMake(SCREEN_WIDTH - 13 - , 20, 63, 49);
//    navigationRight.titleLabel.font = [UIFont systemFontOfSize:20];//My_FontName(12.0f);
//    navigationRight.hidden = YES;
//    [navigationRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [navigationRight addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [navigationViewBg addSubview:navigationRight];
////    self.view.backgroundColor = My_ViewBgColor;//背景色
}

#pragma mark - 左边按钮图片设置
//-(void)leftBarButtonItemImage:(UIImage *)image leftBool:(BOOL)left{
//
//
//    UIBarButtonItem* leftbarItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
//    self.navigationItem.leftBarButtonItem = leftbarItem;
//    self.navigationItem.leftBarButtonItem.tintColor = My_COLOR_RGB(123, 78, 0);
//    
//    
//    
//}

#pragma mark - 右边按钮图片设置
//-(void)rightBarButtonItemImage:(UIImage *)image{
//    
//    UIImage * backImage_right = image;
//    CGRect backframe_right = CGRectMake(0,0,20,20);
//    but_right = [[UIButton alloc] initWithFrame:backframe_right];
//    [but_right setBackgroundImage:backImage_right forState:UIControlStateNormal];
//    but_right.titleLabel.font = [UIFont systemFontOfSize:13];
//    [but_right addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    but_right.hidden = NO;//默认显示
//    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:but_right];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//}


//#pragma mark - 右边按钮文字设置
//-(void)rightBarButtonItemTitle:(NSString *)title{
//    
//    CGRect backframe_right = CGRectMake(0,0,70,20);
//    but_right = [[UIButton alloc] initWithFrame:backframe_right];
//    [but_right setTitle:title forState:UIControlStateNormal];
//    [but_right setTitleColor:My_COLOR_RGB(123, 78, 0) forState:UIControlStateNormal];
//    but_right.titleLabel.font = My_FontName(15.0f);
//    [but_right addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    but_right.hidden = NO;//默认显示
//    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:but_right];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//}
//
//
//#pragma mark - 左边按钮显示状态
//-(void)leftBarButtonHidden:(BOOL)isbool{
//    
//    self.navigationLeft.hidden = isbool;
//    
//}
//
//
//#pragma mark - 右边按钮显示状态
//-(void)rightBarButtonHidden:(BOOL)isbool{
//    
//    but_right.hidden = isbool;
//}
//
//
#pragma mark - 左边按钮事件
-(void)leftBarButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 右边按钮事件
-(void)rightBarButtonClick{
    
}

#pragma mark - 给控制器title赋值
- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.navigationTitle.text = [NSString stringWithFormat:@" %@ ",titleName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [JJHud dismiss];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//}

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
- (void)dealloc {
    DebugLog(@"%@销毁",self.class);
}
@end

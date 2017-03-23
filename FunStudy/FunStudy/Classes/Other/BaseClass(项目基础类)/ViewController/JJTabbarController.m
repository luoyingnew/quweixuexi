//
//  JJTabbarController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTabbarController.h"
#import "JJNavigationController.h"
#import "JJFunStudyViewController.h"
#import "JJFunClassViewController.h"
#import "JJMYAchievementViewController.h"
#import "JJTabbar.h"

@interface JJTabbarController ()<JJTabBarDelegate>



@end

@implementation JJTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    /**** 设置所有UITabBarItem的文字属性 ****/
    [self setupItemTitleTextAttributes];
    
    /**** 添加子控制器 ****/
    [self setupChildViewControllers];
    
    /**** 更换TabBar ****/
//    [self setupTabBar];

}

/**
 *  设置所有UITabBarItem的文字属性
 */
- (void)setupItemTitleTextAttributes
{
//    UITabBarItem *item = [UITabBarItem appearance];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [self.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
//    // 普通状态下的文字属性
//    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
//    
//    // 选中状态下的文字属性
//    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
//    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

/**
 *  添加子控制器
 */
- (void)setupChildViewControllers
{
    JJNavigationController *FunStudyViewController =[[JJNavigationController alloc] initWithRootViewController:[[JJFunStudyViewController alloc] init]];
    FunStudyViewController.navigationBarHidden = YES;
    [self setupOneChildViewController:FunStudyViewController title:nil image:@"FunStudyNormal" selectedImage:@"FunStudySelected"];
    
    JJNavigationController *FunClassViewController =[[JJNavigationController alloc] initWithRootViewController:[[JJFunClassViewController alloc] init]];
    FunClassViewController.navigationBarHidden = YES;
    if([User getUserInformation].user_class) {
        //如果是已经有班级的
        [self setupOneChildViewController:FunClassViewController title:nil image:@"FunClassNormal" selectedImage:@"FunClassSelected"];
    } else {
        //如果是没有班级的自学用户
         [self setupOneChildViewController:FunClassViewController title:nil image:@"FunClassJoinNormal" selectedImage:@"FunClassSelected"];
    }
    
    
    JJNavigationController *MYAchievementViewController =[[JJNavigationController alloc] initWithRootViewController:[[JJMYAchievementViewController alloc] init]];
    MYAchievementViewController.navigationBarHidden = YES;
    [self setupOneChildViewController:MYAchievementViewController title:nil image:@"MyCenterNormal" selectedImage:@"MyCenterSelected"];
}

/**
 *  初始化一个子控制器
 *
 *  @param vc            子控制器
 *  @param title         标题
 *  @param image         图标
 *  @param selectedImage 选中的图标
 */
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
//    vc.tabBarItem.title = title;
    if (image.length) { // 图片名有具体值
        vc.tabBarItem.image = [[UIImage imageNamed:image ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        vc.tabBarItem 
//        vc.tabBarItem.badgeColor = RandomColor;
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self addChildViewController:vc];
    // 2.根据对应的子控制器创建子控制器对应的按钮
    [self.customTabBar addTabBarButton:vc.tabBarItem];
}

#pragma mark - IWTabBarDelegate
- (void)tabBar:(JJTabbar *)tabBar didSelectFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
    
}


- (JJTabbar *)customTabBar
{
    if (_customTabBar == nil) {
        // 1.创建自定义TabBar
        JJTabbar *customTabBar = [[JJTabbar alloc] init];
        
        customTabBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, TABAR_HEIGHT);
        customTabBar.delegate = self;
        [self.tabBar addSubview:customTabBar];
//       [customTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.equalTo(self.tabBar);
//        }];
        
        self.customTabBar = customTabBar;
    }
    return _customTabBar;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self removeTabBarButton];
//    
//}

//- (void)removeTabBarButton
//{
//    for (UIView *view in self.tabBar.subviews) {
//        // 私有API中的控件 UITabBarButton
//        // 拿不到
//        
//        if ([view isKindOfClass:[UIControl class]]) {
//            // 删除系统自带TabBar上的按钮
//            [view removeFromSuperview];
//        }
//    }
//}
- (void)dealloc
{
    DebugLog(@"IWTabbarController销毁");
    
}

- (void)viewWillLayoutSubviews{
    //换成在这个地方去除系统tabbarItm主要是因为在viewWillAppear中去除完后下次可能又会出现系统的tabbaritem
    [super viewWillLayoutSubviews];
    for (UIView *child in self.tabBar.subviews) {
        
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            [child removeFromSuperview];
        }
    }

    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = TABAR_HEIGHT;
    tabFrame.origin.y = self.view.frame.size.height - TABAR_HEIGHT;
    self.tabBar.frame = tabFrame;
//    UITabBar *tabBar = self.tabBar;
//    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
//////    DebugLog(@"tb1%ld",tabBarItem1.)
////    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
////    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
//    tabBarItem1.imageInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
}


//
////- (void)setSelectedIndex:(NSUInteger)selectedIndex {
////    UITabBar *tabBar = self.tabBar;
////    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
////    //    DebugLog(@"tb1%ld",tabBarItem1.)
////    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
////    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
////    tabBarItem1.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
////    tabBarItem2.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
////    tabBarItem3.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
////    tabBar.items[selectedIndex].imageInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
////    NSLog(@"dsf");
////
////}
//
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
//    //    DebugLog(@"tb1%ld",tabBarItem1.)
//    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
//    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
//    tabBarItem1.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    tabBarItem2.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    tabBarItem3.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    item.imageInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
//    NSLog(@"dsf");
//}
@end

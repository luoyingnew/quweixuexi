//
//  JJTabbar.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTabbar.h"
#import "JJTabbaButton.h"
#import "JJTabbarController.h"
#import "JJNavigationController.h"

@interface JJTabbar ()


@property (nonatomic, weak) JJTabbaButton  * selectedBtn;

@end

@implementation JJTabbar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //添加通知方便tabbar的跳转
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pop:) name:POP object:nil];
        //自学用户添加班级成功
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successJoinClass) name:SuccessJoinClass object:nil];
    }
    return self;
}

- (void)pop:(NSNotification *)noti
{
    
    if([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[JJTabbarController class]]) {
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        }];
        JJTabbarController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if(tabbarController.selectedIndex == 0) {
            //如果当前tabbar是在第0个
            JJNavigationController *navigationVC = tabbarController.selectedViewController;
            [navigationVC popToRootViewControllerAnimated:YES];
        } else {
            //如果当前tabbar是第1个和第二个
            NSNumber *number = noti.object;
            int index = number.intValue;
            JJTabbaButton *button = self.buttons[index];
            [self btnOnClick:button];
        }
        
    }
}

- (void)successJoinClass {
    JJTabbaButton *btn = self.buttons[1];
    if([User getUserInformation].user_class) {
        //如果是已加入班级用户
        [btn setImage:[UIImage imageNamed:@"FunClassNormal"] forState:UIControlStateNormal];
    } else {
        //如果是自学用户
        [btn setImage:[UIImage imageNamed:@"FunClassJoinNormal"] forState:UIControlStateNormal];
    }

    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // 2.设置选项卡按钮的frame
    [self setupTabBarButtonFrame];
}
/**
 *  设置选项卡按钮的frame
 */
- (void)setupTabBarButtonFrame
{
    // 便利选项卡按钮设置frame
    NSInteger count = self.buttons.count;
    CGFloat height = self.height;
    CGFloat width = self.width / (self.buttons.count);
    for (int i = 0; i < count; i++) {
        // 1.取出对应位置的按钮
        UIButton *btn = self.buttons[i];
        // 2.设置frame
        btn.height = height;
        btn.width =  width;// 加上添加按钮
        btn.top = 0;
        btn.left = i * btn.width;
        
    }
}

/**
 *  添加选项卡按钮
 */
- (void)addTabBarButton:(UITabBarItem *)item
{
    // 1.创建对应自控制器的按钮
    JJTabbaButton *btn = [[JJTabbaButton alloc] init];
    
    // 2.设置按钮显示的内容
    btn.item = item;
    
    // 监听按钮点击事件
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchDown];
    
    // 设置tag
    btn.tag = self.buttons.count;
    
    // 3.添加按钮到当前view
    [self addSubview:btn];
    
    // 4.将刚刚创建的选项卡按钮添加到数组中
    [self.buttons addObject:btn];
    
    // 5.设置默认选中
    if (self.buttons.count == 1) {
        
        
        [self btnOnClick:btn];
        
    }
    
}

/**
 *  监听选项卡按钮点击
 */
- (void)btnOnClick:(JJTabbaButton *)btn
{
    //    IWLog(@"btnOnClick");
    // 1.取消上次选中
    self.selectedBtn.selected = NO;
    // 2.选中本次
    btn.selected = YES;
    // 3.记录当前选中
    self.selectedBtn = btn;
    
    // 0.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectFrom:to:)]) {
        // 传递上一次选中的按钮的tag, 和当前选中按钮的tag
        [self.delegate tabBar:self didSelectFrom:self.selectedBtn.tag to:btn.tag];
    }
    
    
}

#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:POP object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SuccessJoinClass object:nil];
}
@end

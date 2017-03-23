//
//  JJTabbar.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJTabbar,JJTabbaButton;

@protocol JJTabBarDelegate <NSObject>

- (void)tabBar:(JJTabbar *)tabBar didSelectFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface JJTabbar : UIView

/**
 *  定义数组保存所有的选项卡按钮
 */
@property (nonatomic, strong) NSMutableArray *buttons;
// 懒加载 : 1.用到的时候才加载(节约内存空间)  2.将创建对象的代码封装到一个方法中

/**
 *  定义属性保存选中按钮
 */


/**
 *  提供一个方法给外加创建自定义IWTabBar的按钮
 *
 *  @param item 包含了(图片/选中图片/标题)的模型
 */
- (void)addTabBarButton:(UITabBarItem *)item;

@property (nonatomic, weak) id<JJTabBarDelegate>  delegate;

/**
 *  监听选项卡按钮点击
 */
- (void)btnOnClick:(JJTabbaButton *)btn;
@end

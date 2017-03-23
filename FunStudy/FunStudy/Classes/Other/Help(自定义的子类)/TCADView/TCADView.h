//
//  TCADView.h
//  XPApp
//
//  Created by huangxinping on 15/10/25.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCADView;

typedef void (^TCADSelectedBlock )(UIImageView *imageView, NSString *imagePath, NSUInteger index);

@protocol TCAdViewDelegate <NSObject>



/**
 *  慢加载网络图片   加载图片后
 *
 *  @param adView    广告控件
 *  @param index     索引
 *  @param imageView 控件
 *  @param imageURL  图片URL
 */
- (void)adView:(TCADView *)adView lazyLoadAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imageURL:(NSString *)imageURL;

/**
 *  选择到某个广告      点击之后
 *
 *  @param adView    广告控件
 *  @param index     索引
 *  @param imageView 视图
 *  @param imagePath 图片路径（可能是本地；可能是网络）
 */
- (void)adView:(TCADView *)adView didSelectedAtIndex:(NSUInteger)index imageView:(UIImageView *)imageView imagePath:(NSString *)imagePath;

@end

@interface TCADView : UIView

/**
 *  委托
 */
@property(nonatomic, weak) id<TCAdViewDelegate> delegate;

/**
 *  正在加载广告的过渡图像
 */
@property (nonatomic, strong) UIImage *defalutADImage;

/**
 *  广告数据（本地：图片名称；网络：图片路径）
 */
@property (strong, nonatomic) NSArray *dataArray;

/**
 *  page控件
 */
@property (readonly, nonatomic) UIPageControl *pageControl;

/**
 *  滚动间隔时间，默认是2秒
 */
@property (assign, nonatomic) NSInteger displayTime;

/**
 *  选中block（与前面delegate效果一样）
 */
@property (assign, nonatomic) TCADSelectedBlock selectedBlock;


/**
 *  设置是否为网络图片，默认是YES
 */
@property(nonatomic, assign) BOOL isWebImage;

/**
 *  开始滚动表演
 */
- (void)perform;

@end

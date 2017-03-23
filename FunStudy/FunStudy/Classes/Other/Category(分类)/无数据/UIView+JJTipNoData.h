//
//  UIView+JJTipNoData.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TryOnceAgainBlock)(void);

@interface UIView (JJTipNoData)

/**
 返回无数据时
 
 @param imageName 图片名   传nil会有一个默认图
 @param title     描述
 */
- (void)showNoDateWithTitle:(NSString *)title;

- (void)hideNoDate;



@end

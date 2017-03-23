//
//  JJBaseNavigationBar.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/7.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseNavigationBar.h"

@interface JJBaseNavigationBar()

@end

@implementation JJBaseNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark - 懒加载
- (UIButton *)leftButton {
    if (!_leftButton) {
        
    }
    return _leftButton;
}

@end

//
//  JJMyAchievementCenterBtn.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyAchievementCenterBtn.h"

@interface JJMyAchievementCenterBtn ()


@end

@implementation JJMyAchievementCenterBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(78, 125, 213, 1);
        [self createBordersWithColor:[UIColor clearColor] withCornerRadius:8 andWidth:0];
        self.topTitle = [[UILabel alloc]init];
        self.topTitle.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
        self.topTitle.textColor = [UIColor whiteColor];
        self.topTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topTitle];
        [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.5);
        }];
        
        self.bottomTitle = [[UILabel alloc]init];
        self.bottomTitle.textColor = [UIColor whiteColor];
        self.bottomTitle.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
        self.bottomTitle.textAlignment = NSTextAlignmentCenter;
//        self.bottomTitle.backgroundColor = [UIColor redColor];
        [self addSubview:self.bottomTitle];
        [self.bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.5);
        }];
    }
    return self;
}

@end

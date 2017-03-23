//
//  JJTipNotData.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTipNotData.h"

@implementation JJTipNotData

+ (instancetype)tipTryOnceView {
    JJTipNotData *tipTryOnceView = [[JJTipNotData alloc]init];
    
    return tipTryOnceView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setBaseView];
    }
    return self;
}

- (void)setBaseView {
    self.backgroundColor = [UIColor clearColor];//RGBA(238, 238, 238, 1);
    self.noInternetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NoDataIcon"]];
    [self addSubview:self.noInternetImageView];
    [self.noInternetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(141 * KWIDTH_IPHONE6_SCALE));
        make.height.mas_equalTo(147 * KWIDTH_IPHONE6_SCALE);
        make.center.equalTo(self);
//        make.top.equalTo(self).with.offset(128 * KWIDTH_IPHONE6_SCALE);
    }];
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.backgroundColor = RGBA(252, 129, 0, 1);
    [self.tipLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:8 andWidth:0];
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.text = @"还没有记录~";
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(27 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self);
        make.top.equalTo(self.noInternetImageView.mas_bottom).with.offset(5 *KWIDTH_IPHONE6_SCALE);
    }];
}


@end

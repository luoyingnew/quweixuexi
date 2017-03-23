//
//  JJMessageButton.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/19.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMessageButton.h"

@interface JJMessageButton ()

@property (nonatomic, strong) UIView *redView;


@end

@implementation JJMessageButton

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.redView = [[UIView alloc]init];
        self.redView.hidden = YES;
        self.isHideTip = YES;
        self.redView.backgroundColor = [UIColor redColor];
        [self addSubview:self.redView];
        [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(8 * KWIDTH_IPHONE6_SCALE);
            make.top.right.equalTo(self);
        }];
        [self.redView createBordersWithColor:[UIColor clearColor] withCornerRadius:4 * KWIDTH_IPHONE6_SCALE andWidth:0];
    }
    return self;
}


- (void)setIsHideTip:(BOOL)isHideTip {
    _isHideTip = isHideTip;
    self.redView.hidden = isHideTip;
}
@end

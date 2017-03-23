//
//  JJFunAlerView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunAlerView.h"


@interface JJFunAlerView ()

@property (nonatomic, copy) CertainBlock block;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation JJFunAlerView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.2);
        weakSelf(weakSelf);
        [self whenTapped:^{
            [weakSelf hide];
        }];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alertViewBack"]];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(293 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(173 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //title名
        UILabel *titleLabel = [[UILabel alloc]init];
        self.titleLabel = titleLabel;
        self.titleLabel.font = [UIFont systemFontOfSize:18 * KWIDTH_IPHONE6_SCALE];
        titleLabel.text = @"title";
        [imageView addSubview:titleLabel];
        titleLabel.textColor = RGBA(166, 66, 0, 1);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(70 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(self);
        }];
        
        //取消按钮
        UIButton *cancleBtn = [[UIButton alloc]init];
        [cancleBtn setBackgroundImage:[UIImage imageNamed:@"alertCancleBtn"] forState:UIControlStateNormal];
        [imageView addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.with.offset(-22 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(62 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(71 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
        }];
        //确定按钮
        UIButton *certainBtn =[[UIButton alloc]init];
        [certainBtn setBackgroundImage:[UIImage imageNamed:@"alertCertainBtn"] forState:UIControlStateNormal];
        [certainBtn addTarget:self action:@selector(certainBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:certainBtn];
        [certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.with.offset(-22 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-62 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(71 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(28 * KWIDTH_IPHONE6_SCALE);
        }];

        
    }
    return self;
}

+ (void)showFunAlertViewWithTitle:(NSString *)title CenterBlock:(CertainBlock)block {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    JJFunAlerView *alerV = [[JJFunAlerView alloc]initWithFrame:keyWindow.bounds];
    alerV.titleLabel.text = title;
    [keyWindow addSubview:alerV];
    
    alerV.block = block;
}

- (void)certainBtnClick {
    if(self.block) {
        self.block();
    }
    [self hide];
}
- (void)hide {
    [self removeFromSuperview];
}

@end

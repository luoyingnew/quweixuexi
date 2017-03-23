//
//  JJProgressView.m
//  进度条
//
//  Created by 唐天成 on 2016/11/20.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJProgressView.h"
#import "UIView+FrameExpand.h"
#import "Masonry.h"
@interface JJProgressView()

@property (nonatomic, strong) UIView *imageV1;
@property (nonatomic, strong) UIView *imageV2BackView;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UIImageView *headImageV;



@end

@implementation JJProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UIImageView *imageV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        self.imageV1 = imageV1;
        imageV1.backgroundColor = RGBA(107, 236, 255, 1);
//        imageV1.frame = CGRectMake(10, 230, 300, 40);
        [self addSubview:imageV1];
       
        UIView *imageV2BackView = [[UIView alloc]init];
        self.imageV2BackView = imageV2BackView;
        self.imageV2BackView.clipsToBounds = YES;
        //    imageV2BackView.width = 300;
//        imageV2BackView.backgroundColor = [UIColor Color];//RGBA(0, 0, 0, 0.5);
        [imageV1 addSubview:imageV2BackView];
              
        UIImageView *imageV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        self.imageV2 = imageV2;
        imageV2.backgroundColor = [UIColor whiteColor];
        [imageV2BackView addSubview:imageV2];
        UIImageView *headImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ProgressHead"]];
        self.headImageV = headImageV;
        [self addSubview:headImageV];
       
        [self.imageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
        //    [self.imageV1 createBordersWithColor:[UIColor blackColor] withCornerRadius:self.height/2 andWidth:2];
        [self.imageV2BackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.imageV1);
        }];
        [self.imageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
            //            make.width.mas_equalTo(self.width);
        }];
        
        [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@60);
            make.width.mas_equalTo(37);
            make.height.mas_equalTo(31);
            make.centerY.equalTo(self.imageV1);
            make.centerX.equalTo(self.imageV2BackView.mas_left);
        }];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageV1 createBordersWithColor:RGBA(0, 92, 168, 1) withCornerRadius:self.height/2 andWidth:2];
}

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    [self.imageV2BackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(self.width * progressValue);
    }];
    [self layoutIfNeeded];

}

@end

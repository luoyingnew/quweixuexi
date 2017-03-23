//
//  JJRecordResultView.m
//  FunStudy
//
//  Created by 唐天成 on 2017/2/7.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJRecordResultView.h"

@interface JJRecordResultView ()

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation JJRecordResultView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UIView *backView = [[UIView alloc]init];
        [self addSubview:backView];
        backView.backgroundColor = RGBA(0, 0, 0, 0.5);
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.with.offset(0);
        }];
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(200 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

- (void)setType:(RecordGradeType)type {
    if(type == RecordGrade80){
        //60-80
        self.imageView.image = [UIImage imageNamed:@"score60~80"];
    } else if(type == RecordGrade90){
        //80-90
        self.imageView.image = [UIImage imageNamed:@"score80~90"];
    }else {
        //90-100
        self.imageView.image = [UIImage imageNamed:@"score90~100"];
    }
}

@end

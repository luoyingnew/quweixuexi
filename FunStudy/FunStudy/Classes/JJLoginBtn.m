//
//  JJLoginBtn.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJLoginBtn.h"

@implementation JJLoginBtn

+ (instancetype)loginBtnWithFrame:(CGRect)frame btnName:(NSString *)btnName numberString:(NSString *)numberString target:(id)target action:(SEL)action {
    JJLoginBtn *loginBtn = [[JJLoginBtn alloc]initWithFrame:frame];
    loginBtn.numberLabel.text = numberString;
    [loginBtn.btn setTitle:btnName forState:UIControlStateNormal];
    [loginBtn.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return loginBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor greenColor];
        self.btn = [[UIButton alloc]init];
        self.btn.titleLabel.font = [UIFont boldSystemFontOfSize:21 * KWIDTH_IPHONE6_SCALE];
        [self.btn setBackgroundImage:[UIImage imageNamed:@"Login_Next_Btn"] forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.btn.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.btn];
        [self.btn createBordersWithColor:[UIColor clearColor] withCornerRadius:10*KWIDTH_IPHONE6_SCALE andWidth:2*KWIDTH_IPHONE6_SCALE];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(112.0 / 151 * frame.size.height));
            make.width.equalTo(@(frame.size.width - frame.size.height / 2));
            make.right.equalTo(self);
            make.centerY.equalTo(self);
        }];

        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star"]];
//        imageView.backgroundColor = [UIColor purpleColor];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(self.mas_height);
        }];
        
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.font = [UIFont systemFontOfSize:9*KWIDTH_IPHONE6_SCALE];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(imageView);
        }];
        
    }
    return self;
}

@end

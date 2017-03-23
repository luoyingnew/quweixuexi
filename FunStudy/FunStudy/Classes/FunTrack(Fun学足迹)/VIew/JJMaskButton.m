//
//  JJMaskButton.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMaskButton.h"

@interface JJMaskButton ()

@property (nonatomic, strong) UIView *maskView;


@end

@implementation JJMaskButton

- (instancetype)initWithFrame:(CGRect)frame {
    if(self ==  [super initWithFrame:frame]) {
        UIView *maskView = [[UIView alloc]init];
        maskView.userInteractionEnabled = YES;
        maskView.hidden = YES;
        [maskView createBordersWithColor:[UIColor clearColor] withCornerRadius:18 * KWIDTH_IPHONE6_SCALE andWidth:0];
        self.maskView = maskView;
        maskView.backgroundColor = RGBA(0, 0, 0, 0.6);
        [self addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    if(selected == YES) {
//        self.maskView.hidden = NO;
//    } else {
//        self.maskView.hidden = YES;
//    }
//}

@end

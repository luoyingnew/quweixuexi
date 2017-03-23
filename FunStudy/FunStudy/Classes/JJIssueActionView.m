//
//  JJIssueActionView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/10.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJIssueActionView.h"

@interface JJIssueActionView()

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIView *cancleBtn;

@end

@implementation JJIssueActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
//        __weak typeof(self)alertV = self;
        weakSelf(weakSelf);
        [self whenTapped:^{
            [weakSelf actionViewHide];
        }];
        self.backgroundColor = RGBA(0, 0, 0, 0.2);
        
        //取消按钮
        UIButton *cancleBtn = [[UIButton alloc]init];
        self.cancleBtn = cancleBtn;
        [cancleBtn setBackgroundColor:[UIColor whiteColor]];
        [cancleBtn addTarget:self action:@selector(actionViewHide) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
        [cancleBtn createBordersWithColor:NORMAL_COLOR withCornerRadius:(40 * KWIDTH_IPHONE6_SCALE)/2 andWidth:2];
        [self addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.mas_equalTo(257 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(40 * KWIDTH_IPHONE6_SCALE);
            make.bottom.mas_equalTo(204 * KWIDTH_IPHONE6_SCALE);
        }];
        
        UIView *borderView = [[UIView alloc]init];
        borderView.backgroundColor = [UIColor whiteColor];
        [borderView createBordersWithColor:NORMAL_COLOR withCornerRadius:(40 * KWIDTH_IPHONE6_SCALE)/2 andWidth:2];
        [self addSubview:borderView];
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(108 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(270 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(self);
            make.bottom.equalTo(cancleBtn.mas_top).with.offset(-16 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //忘记密码按钮
        UIButton *forgetPasswortBtn = [[UIButton alloc]init];
        [forgetPasswortBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:5 andWidth:0];
        [forgetPasswortBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [forgetPasswortBtn setBackgroundColor:NORMAL_COLOR];
        [forgetPasswortBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [borderView addSubview:forgetPasswortBtn];
        [forgetPasswortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(borderView);
            make.height.mas_equalTo(30 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(224 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(borderView).with.offset(16 * KWIDTH_IPHONE6_SCALE);
        }];
        [forgetPasswortBtn layoutIfNeeded];
        
        //虚线
        UIView *topLineView = [UIView dashLineWithFrame:CGRectMake(0, 0, 224 * KWIDTH_IPHONE6_SCALE, 2) lineLength:2 lineSpacing:2 lineColor:NORMAL_COLOR];
        [borderView addSubview:topLineView];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(borderView);
            make.top.equalTo(forgetPasswortBtn.mas_bottom).with.offset(8 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(224 * KWIDTH_IPHONE6_SCALE);
        }];
        
//        //使用手机验证码登录
//        UIButton *usePhoneBtn = [[UIButton alloc]init];
//        [usePhoneBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:5 andWidth:0];
//        [usePhoneBtn addTarget:self action:@selector(userPhoneCode) forControlEvents:UIControlEventTouchUpInside];
//        [usePhoneBtn setBackgroundColor:NORMAL_COLOR];
//        [usePhoneBtn setTitle:@"使用手机验证码登录" forState:UIControlStateNormal];
//        [borderView addSubview:usePhoneBtn];
//        [usePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(borderView);
//            make.height.mas_equalTo(30 * KWIDTH_IPHONE6_SCALE);
//            make.width.mas_equalTo(224 * KWIDTH_IPHONE6_SCALE);
//            make.top.equalTo(forgetPasswortBtn.mas_bottom).with.offset(16 * KWIDTH_IPHONE6_SCALE);
//        }];
//        
//        //虚线
//        UIView *bottomLineView = [UIView dashLineWithFrame:CGRectMake(0, 0, 224 * KWIDTH_IPHONE6_SCALE, 2) lineLength:2 lineSpacing:2 lineColor:NORMAL_COLOR];
//        [borderView addSubview:bottomLineView];
//        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(borderView);
//            make.top.equalTo(usePhoneBtn.mas_bottom).with.offset(8 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(2);
//            make.width.mas_equalTo(224 * KWIDTH_IPHONE6_SCALE);
//        }];
        
        //进入帮助中心
        UIButton *helpCenterBtn = [[UIButton alloc]init];
        [helpCenterBtn addTarget:self action:@selector(enterHelpCenter) forControlEvents:UIControlEventTouchUpInside];
        [helpCenterBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:5 andWidth:0];
        [helpCenterBtn setBackgroundColor:NORMAL_COLOR];
        [helpCenterBtn setTitle:@"进入帮助中心" forState:UIControlStateNormal];
        [borderView addSubview:helpCenterBtn];
        [helpCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(borderView);
            make.height.mas_equalTo(30 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(224 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(forgetPasswortBtn.mas_bottom).with.offset(16 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

//忘记密码
- (void)forgetPassword {
    [self actionViewHide];
    if([self.delegate respondsToSelector:@selector(actionViewDidSelectedIndex:)]) {
        [self.delegate actionViewDidSelectedIndex:0];
    }
}
////使用手机验证码登录
//- (void)userPhoneCode {
//    [self actionViewHide];
//    if([self.delegate respondsToSelector:@selector(actionViewDidSelectedIndex:)]) {
//        [self.delegate actionViewDidSelectedIndex:1];
//    }
//}
//进入帮助中心
- (void)enterHelpCenter {
    [self actionViewHide];
    if([self.delegate respondsToSelector:@selector(actionViewDidSelectedIndex:)]) {
        [self.delegate actionViewDidSelectedIndex:1];
    }
}

- (void)actionViewHide {
    [self.cancleBtn.superview layoutIfNeeded];
    [self.cancleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(204 * KWIDTH_IPHONE6_SCALE);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.cancleBtn.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)actionViewShow {
    self.hidden = NO;
    [self.cancleBtn.superview layoutIfNeeded];
    [self.cancleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-35 * KWIDTH_IPHONE6_SCALE);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.cancleBtn.superview layoutIfNeeded];
    }];
}
@end

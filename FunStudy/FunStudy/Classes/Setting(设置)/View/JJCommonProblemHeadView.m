//
//  JJCommonProblemHeadView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/2.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCommonProblemHeadView.h"
#import "FeedbackViewController.h"
#import "UIView+viewController.h"

@interface JJCommonProblemHeadView ()

@property (nonatomic, strong) UILabel *leftQuestionLabel;
@property (nonatomic, strong) UIButton *rightMoreQuestionBtn;

@end

@implementation JJCommonProblemHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc]init];
        self.backView = backView;
        backView.backgroundColor = RGBA(41, 188 , 254, 1);
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.center.equalTo(self.contentView);
            make.left.right.equalTo(self);
            make.top.with.offset(10 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        }];
        self.leftQuestionLabel = [[UILabel alloc]init];
        self.leftQuestionLabel.font = [UIFont boldSystemFontOfSize:19 * KWIDTH_IPHONE6_SCALE];
        self.leftQuestionLabel.text = @"作业问题";
        [backView addSubview:self.leftQuestionLabel];
        [self.leftQuestionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(16 * KWIDTH_IPHONE6_SCALE);
            make.top.with.offset(0 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(0 * KWIDTH_IPHONE6_SCALE);
        }];
        
        self.rightMoreQuestionBtn = [[UIButton alloc]init];
        self.rightMoreQuestionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
        [self addSubview:self.rightMoreQuestionBtn];
        [self.rightMoreQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.with.offset(-18 * KWIDTH_IPHONE6_SCALE);
        }];
        [self.rightMoreQuestionBtn setTitle:@"更多问题 >" forState:UIControlStateNormal];
        [self.rightMoreQuestionBtn addTarget:self action:@selector(pushToMoreQuestionVC) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)pushToMoreQuestionVC {
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc]init];
    [self.viewController.navigationController pushViewController:feedbackVC animated:YES];
}

- (void)setModel:(JJCommonProblemModel *)model {
    _model = model;
    self.leftQuestionLabel.text = model.leftQuestion;
    [self.rightMoreQuestionBtn setTitle:[NSString stringWithFormat:@"%@ >",model.rightQuestion] forState:UIControlStateNormal];
}

@end

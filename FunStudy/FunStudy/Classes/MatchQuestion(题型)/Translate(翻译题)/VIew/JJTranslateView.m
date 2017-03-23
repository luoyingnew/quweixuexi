//
//  JJTranslateView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTranslateView.h"
#import <ReactiveCocoa.h>

@interface JJTranslateView ()

//类型
//@property(nonatomic,assign)TranslateTestType type;
//问题Label
@property (nonatomic, strong) UILabel *questionLabel;


@end

@implementation JJTranslateView

+(instancetype)translateViewWithSingleTranslateModel:(JJTranslateModel *)model{
    JJTranslateView *translateView = [[JJTranslateView alloc]init];
    translateView.translateModel = model;
//    translateView.type = type;
    [translateView setbaseView];
    return translateView;
}

- (void)setbaseView {
    //将下列句子翻译成label
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    textLabel.textColor = RGBA(136, 0, 0, 1);
    [self addSubview:textLabel];
    [textLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:9.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.left.with.offset(50 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.left.with.offset(75 * KWIDTH_IPHONE6_SCALE);
        }
        make.height.mas_equalTo(19 * KWIDTH_IPHONE6_SCALE);
    }];
//    if(self.type == SingleEnToCH) {
//        //如果是英->汉
    textLabel.text = [NSString stringWithFormat:@" %@ ",self.translateModel.topic_title];//@" 请翻译下列句子 ";
//    } else {
//        //如果是汉->英
//        textLabel.text = @" 将下列句子翻译成英文 ";
//    }
    
    //问题label
    UILabel *questionLabel = [[UILabel alloc]init];
    self.questionLabel = questionLabel;
    questionLabel.text =[NSString stringWithFormat:@" %@ ",  self.translateModel.question];
    questionLabel.backgroundColor = RGBA(0, 151, 205, 1);
    questionLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    questionLabel.textColor = [UIColor whiteColor];
    questionLabel.numberOfLines = 2;
    [self addSubview:questionLabel];
    [questionLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:9.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(64 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.left.with.offset(50 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.left.with.offset(75 * KWIDTH_IPHONE6_SCALE);
        }
        make.right.lessThanOrEqualTo(self).with.offset(-50 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_greaterThanOrEqualTo(19 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //请翻译
    UILabel *pleaseTransLateLabel = [[UILabel alloc]init];
    [self addSubview:pleaseTransLateLabel];
    pleaseTransLateLabel.text = @"请翻译:";
    pleaseTransLateLabel.textColor = RGBA(0, 151, 205, 1);
    pleaseTransLateLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
    [pleaseTransLateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionLabel.mas_bottom).with.offset(34 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.left.with.offset(50 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.left.with.offset(75 * KWIDTH_IPHONE6_SCALE);
        }
        make.width.mas_equalTo(62 * KWIDTH_IPHONE6_SCALE);
//        make.right.lessThanOrEqualTo(self).with.offset(-50 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_greaterThanOrEqualTo(19 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //输入框textField
    UITextField *textfield = [[UITextField alloc]init];
    @weakify(self);
    [textfield.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        if(text.length == 0) {
            self.translateModel.myAnswer = @"X";
        }else{
            self.translateModel.myAnswer = text;
        }
    }];
    self.textfield = textfield;
    textfield.textColor = RGBA(0, 151, 205, 1);
    [self addSubview:textfield];
    textfield.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pleaseTransLateLabel.mas_right);
        make.height.mas_greaterThanOrEqualTo(19 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.right.with.offset(-45 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.right.with.offset(-75 * KWIDTH_IPHONE6_SCALE);
        }
        make.bottom.equalTo(pleaseTransLateLabel.mas_bottom);
    }];
    //下划线
    UIView *lineView = [[UIView alloc]init];
    [textfield addSubview:lineView];
    lineView.backgroundColor = RGBA(0, 151, 205, 1);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(textfield);
        make.height.mas_equalTo(1 * KWIDTH_IPHONE6_SCALE);
    }];

}



@end

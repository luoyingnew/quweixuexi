//
//  JJErrorCorrectionView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJErrorCorrectionView.h"
#import <ReactiveCocoa.h>
#import "UIButton+Custom.h"
#import "XPTextView.h"

@interface JJErrorCorrectionView ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;




@end


@implementation JJErrorCorrectionView

+(instancetype)errorCorrectionViewWithModel:(JJErrorCorrectionModel *)model{
    JJErrorCorrectionView *errorCorrectionView = [[JJErrorCorrectionView alloc]init];
    errorCorrectionView.errorCorrectionModel = model;
    [errorCorrectionView setbaseView];
    return errorCorrectionView;
}

- (void)setbaseView {
    //将下列句子翻译成label
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:10 * KWIDTH_IPHONE6_SCALE];
    textLabel.textColor = RGBA(136, 0, 0, 1);
    [self addSubview:textLabel];
    textLabel.numberOfLines = 0;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.left.with.offset(50 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.left.with.offset(75 * KWIDTH_IPHONE6_SCALE);
        }
        make.right.with.offset(-67 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(27 * KWIDTH_IPHONE6_SCALE);
    }];
//    textLabel.textAlignment = NSTextAlignmentCenter;
    NSString *text =self.errorCorrectionModel.topic_title;//@"判断以下句子是否正确，确定的打✅，不正确的将句子改写正确";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.headIndent = 10*KWIDTH_IPHONE6_SCALE;
    paragraphStyle.firstLineHeadIndent = 10 * KWIDTH_IPHONE6_SCALE;
//    paragraphStyle.tailIndent = 10 * KWIDTH_IPHONE6_SCALE;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    textLabel.attributedText = attributedString;
    [textLabel sizeToFit];
//    textLabel.text = @"";
//    [self layoutIfNeeded];
    
    [textLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:13.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    
    
    
    
    //问题label
    UILabel *questionLabel = [[UILabel alloc]init];
//    self.questionLabel = questionLabel;
    NSString *s = self.errorCorrectionModel.question;
    questionLabel.text = [self.errorCorrectionModel.question stringByReplacingOccurrencesOfString:@"#"withString:@"\n"];//  [NSString stringWithFormat:@"%@",  self.errorCorrectionModel.question];
//    questionLabel.backgroundColor = RGBA(0, 151, 205, 1);
    questionLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    questionLabel.textColor = RGBA(0, 94, 131, 1);
    questionLabel.numberOfLines = 3;
    questionLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:questionLabel];
//    [questionLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:9.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(76 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.left.with.offset(57 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.left.with.offset(75 * KWIDTH_IPHONE6_SCALE);
        }
        //make.left.with.offset(57 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.right.with.offset(-106 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.right.with.offset(-126 * KWIDTH_IPHONE6_SCALE);
        }
//        make.right.with.offset(-106 * KWIDTH_IPHONE6_SCALE);
    }];
    //勾号
    UIButton *truebtn = [[UIButton alloc]init];
    [truebtn setEnlargeEdgeWithTop:20 * KWIDTH_IPHONE6_SCALE right:0 bottom:20 * KWIDTH_IPHONE6_SCALE left:20 * KWIDTH_IPHONE6_SCALE];
    [truebtn addTarget:self action:@selector(trueBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    Truebtn.backgroundColor = [UIColor redColor];
    [self addSubview:truebtn];
    [truebtn setBackgroundImage:[UIImage imageNamed:@"MatchQuestionTrue"] forState:UIControlStateNormal];
    [truebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(17 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(questionLabel);
        make.left.equalTo(questionLabel.mas_right);
    }];
    
    
    //叉号
    UIButton *falsebtn = [[UIButton alloc]init];
    [falsebtn setEnlargeEdgeWithTop:20 * KWIDTH_IPHONE6_SCALE right:20 * KWIDTH_IPHONE6_SCALE bottom:20 * KWIDTH_IPHONE6_SCALE left:0 ];
//    Truebtn.backgroundColor = [UIColor redColor];
    [falsebtn addTarget:self action:@selector(falseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:falsebtn];
    [falsebtn setBackgroundImage:[UIImage imageNamed:@"MatchQuestionFalse"] forState:UIControlStateNormal];
    [falsebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(17 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(17 * KWIDTH_IPHONE6_SCALE);
        make.centerY.equalTo(questionLabel);
        make.left.equalTo(truebtn.mas_right).with.offset(12 * KWIDTH_IPHONE6_SCALE);
    }];

    
    //请输入正确的句子
    UILabel *pleaseinputLabel = [[UILabel alloc]init];
    [self addSubview:pleaseinputLabel];
    pleaseinputLabel.text = @"请输入正确句子:";
    pleaseinputLabel.adjustsFontSizeToFitWidth = YES;
    pleaseinputLabel.textColor = RGBA(0, 151, 205, 1);
    pleaseinputLabel.font = [UIFont boldSystemFontOfSize:13 * KWIDTH_IPHONE6_SCALE];
    [pleaseinputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.with.offset(-80 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.left.with.offset(57 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.left.with.offset(75 * KWIDTH_IPHONE6_SCALE);
        }
        
        
        make.width.mas_equalTo(97 * KWIDTH_IPHONE6_SCALE);
        //        make.right.lessThanOrEqualTo(self).with.offset(-50 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_greaterThanOrEqualTo(14 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //输入框textField
    UITextField *textfield = [[UITextField alloc]init];

    @weakify(self);
    [RACObserve(textfield, text) subscribeNext:^(NSString *text) {
        @strongify(self);
        DebugLog(@"====%@====",text);
        if(text.length == 0) {
            self.errorCorrectionModel.myAnswer = @"X";
        }else{
//            if([text isEqualToString:@"✅"]) {
//                self.errorCorrectionModel.myAnswer = self.errorCorrectionModel.question;
//            }
            self.errorCorrectionModel.myAnswer = text;
        }
    }];
    
    self.textField = textfield;
    textfield.textColor = RGBA(0, 151, 205, 1);
    [self addSubview:textfield];
    textfield.font = [UIFont boldSystemFontOfSize:13 * KWIDTH_IPHONE6_SCALE];
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pleaseinputLabel.mas_right);
        make.height.mas_greaterThanOrEqualTo(14 * KWIDTH_IPHONE6_SCALE);
        if(isPhone) {
            make.right.with.offset(-45 * KWIDTH_IPHONE6_SCALE);
        } else {
            make.right.with.offset(-70 * KWIDTH_IPHONE6_SCALE);
        }
        make.bottom.equalTo(pleaseinputLabel.mas_bottom);
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

- (void)trueBtnClick {
//    self.textField.text = self.errorCorrectionModel.question;
    self.textField.text = @"✅";
    self.errorCorrectionModel.myAnswer = self.errorCorrectionModel.question;
//    self.textField.text = @"1\n2";
//    DebugLog(@"--%@--",self.textField.text);
//    DebugLog(@"--%@--",@"1\n2");
//    NSString *temp;
//    for(int i =0; i < [self.textField.text length]; i++)
//    {
//        temp = [self.textField.text substringWithRange:NSMakeRange(i,1)];
//        if([temp isEqualToString:@"\n"]) {
//            DebugLog(@"hehe");
//        }
//    }
    
}

- (void)falseBtnClick {
    self.textField.text = @"";
}



@end

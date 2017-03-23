//
//  JJMessageCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMessageCell.h"
#import "NSString+XPKit.h"
#import "UILabel+LabelStyle.h"

@interface JJMessageCell ()

//有新测验了Lable
@property (nonatomic, strong) UILabel *haveNewTextLabel;
//截止日期Lable
@property (nonatomic, strong) UILabel *completeDateLabel;
////教材Lable
//@property (nonatomic, strong) UILabel *topicLabel;
////教师Lable
//@property (nonatomic, strong) UILabel *teacherLabel;
//简介
@property (nonatomic, strong) UILabel *introductionLabel;


@property (nonatomic, strong) UILabel *detailLab;


@end

@implementation JJMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        //有新测验了Lable
        UILabel *haveNewTextLabel = [[UILabel alloc]init];
        self.haveNewTextLabel = haveNewTextLabel;
//        haveNewTextLabel.text = @"  有新测验了  ";
        haveNewTextLabel.backgroundColor = RGBA(0, 207, 255, 1);
        [haveNewTextLabel createBordersWithColor:RGBA(0, 193, 235, 1) withCornerRadius:13 * KWIDTH_IPHONE6_SCALE andWidth:1];
        haveNewTextLabel.textAlignment = NSTextAlignmentCenter;
        haveNewTextLabel.textColor = [UIColor whiteColor];
        haveNewTextLabel.font = [UIFont systemFontOfSize:18*KWIDTH_IPHONE6_SCALE];
        [self.contentView addSubview:haveNewTextLabel];
        [haveNewTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(31 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(16 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(29 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //截止日期Lable
        UILabel *completeDateLabel = [[UILabel alloc]init];
        self.completeDateLabel = completeDateLabel;
        [self.contentView addSubview:completeDateLabel];
//        completeDateLabel.text = @"截止时间: 2015年09月19日";
        completeDateLabel.textColor = [UIColor blackColor];
        [completeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(24 * KWIDTH_IPHONE6_SCALE);
            make.top.with.offset(80 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(self.contentView);
        }];
//        //教材Lable
//        UILabel *topicLabel = [[UILabel alloc]init];
//        self.topicLabel = topicLabel;
//        [self.contentView addSubview:topicLabel];
////        topicLabel.text = @"教材：飒美";
//        topicLabel.textColor = [UIColor blackColor];
//        [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.with.offset(24 * KWIDTH_IPHONE6_SCALE);
//            make.top.with.offset(110 * KWIDTH_IPHONE6_SCALE);
//            make.right.equalTo(self.contentView);
//        }];
        
//        //教师Lable
//        UILabel *teacherLabel = [[UILabel alloc]init];
//        self.teacherLabel = teacherLabel;
//        [self.contentView addSubview:teacherLabel];
////        teacherLabel.text = @"教师：王老师";
//        teacherLabel.textColor = [UIColor blackColor];
//        [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.with.offset(24 * KWIDTH_IPHONE6_SCALE);
//            make.top.with.offset(145 * KWIDTH_IPHONE6_SCALE);
//            make.right.equalTo(self.contentView);
//        }];
        
        //带你查看详情label
        UILabel *detailLab = [[UILabel alloc]init];
        self.detailLab = detailLab;
//        detailLab.backgroundColor = [UIColor greenColor];
        detailLab.font = [UIFont systemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
        [detailLab setTextColor:RGBA(157, 31, 241, 1)];
        [detailLab setText:@"点击查看详情" ];
        [self.contentView addSubview:detailLab];
        [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(24 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-44 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(15);
        }];

        
        //简介
        UILabel *introductionLabel = [[UILabel alloc]init];
        self.introductionLabel = introductionLabel;
//        introductionLabel.backgroundColor = [UIColor greenColor];
//        introductionLabel.text = @"简介：背景版小学英语三年级上第一单元试卷UNIT ONE SEPTEM BER 10TH IS THACHERE DAY,共15题";
        introductionLabel.numberOfLines = 0;
        introductionLabel.textColor = [UIColor blackColor];
//        introductionLabel.font = [UIFont systemFontOfSize:25];
        [self.contentView addSubview:introductionLabel];
        [introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(24 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(completeDateLabel.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(self.contentView).with.offset(-20 * KWIDTH_IPHONE6_SCALE);
            make.bottom.lessThanOrEqualTo(detailLab.mas_top).with.offset(0);
        }];
        
    }
    return self;
}

- (void)setModel:(JJMessageModel *)model {
    _model = model;
    if(model.is_exam_homework) {
        self.detailLab.hidden = NO;
    } else {
        self.detailLab.hidden = YES;
    }
    self.haveNewTextLabel.text = model.title;
    CGSize size = [UILabel jj_sizeToFitWithText:model.title Font:self.haveNewTextLabel.font];
    
    
//    [self.haveNewTextLabel headIndentLength:8 * KWIDTH_IPHONE6_SCALE ];
    [self.haveNewTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width + 16 *KWIDTH_IPHONE6_SCALE);
    }];
    
    self.completeDateLabel.text =[NSString stringWithFormat:@"截止时间：%@",[model.createtime stringChangeToDate:@"yyyy年MM月dd日"]];
//    self.topicLabel.text = [NSString stringWithFormat:@"教材：%@",model.title];
//    self.teacherLabel.text = [NSString stringWithFormat:@"教师：%@",model.teacher];
    if(model.detailALlString == nil) {
        model.detailALlString = @"";
    }
    self.introductionLabel.text = [NSString stringWithFormat:@"%@",model.detailALlString];
}

@end

//
//  JJMyTeacherCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyTeacherCell.h"
#import "JJLabel.h"

@interface JJMyTeacherCell ()

//课程类型
@property (nonatomic, strong) UILabel *courseTypeLabel;
//田老师
@property (nonatomic, strong) UILabel *nameLabel;
//编号
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation JJMyTeacherCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createBordersWithColor:RGBA(72, 143, 204, 1) withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:5 * KWIDTH_IPHONE6_SCALE];
        self.contentView.backgroundColor = RGBA(92, 211, 239, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //leftView
        UIView *lefView = [[UIView alloc]init];
        lefView.backgroundColor = RGBA(191, 248, 246, 1);
       [ lefView createBordersWithColor:[UIColor clearColor] withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:0];
        [self.contentView addSubview:lefView];
        [lefView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(13 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(17 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-14 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(112 * KWIDTH_IPHONE6_SCALE);
        }];
        
        JJLabel *courseTypeLabel = [[JJLabel alloc]init];
        self.courseTypeLabel = courseTypeLabel;
        courseTypeLabel.backgroundColor = RGBA(219, 252, 254, 1);
        courseTypeLabel.font = [UIFont boldSystemFontOfSize:34 * KWIDTH_IPHONE6_SCALE];
        courseTypeLabel.textAlignment = NSTextAlignmentCenter;
        courseTypeLabel.text = @"英语";
        courseTypeLabel.textColor = [UIColor whiteColor];
        courseTypeLabel.strokeColor = RGBA(0, 176, 209, 1);
        [lefView addSubview:courseTypeLabel];
        [courseTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(12 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(11 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-11 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-12 * KWIDTH_IPHONE6_SCALE);
        }];
        
        
        //rightView
        UIView *rightView = [[UIView alloc]init];
        rightView.backgroundColor = RGBA(229, 248, 253, 1);
        [ rightView createBordersWithColor:[UIColor clearColor] withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:0];
        [self.contentView addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(13 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-17 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-14 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(136 * KWIDTH_IPHONE6_SCALE);
        }];
        //田老师
        UILabel *nameLabel = [[UILabel alloc]init];
        self.nameLabel = nameLabel;
        [ nameLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:0];
//        nameLabel.backgroundColor = [UIColor redColor];
        [rightView addSubview:nameLabel ];
        [nameLabel setTextColor:NORMAL_COLOR];
        nameLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
        nameLabel.text = @"";
        nameLabel.adjustsFontSizeToFitWidth = YES;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(7 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(11 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-11 * KWIDTH_IPHONE6_SCALE);
        }];
        //编号
        UILabel *numberLabel = [[UILabel alloc]init];
        self.numberLabel = numberLabel;
//        numberLabel.backgroundColor = [UIColor redColor];
        [rightView addSubview:numberLabel ];
        [numberLabel setTextColor:NORMAL_COLOR];
        numberLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
        numberLabel.text = @"";
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).with.offset(11 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(12 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-12 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

- (void)setModel:(JJTeacherModel *)model {
    _model = model;
    self.nameLabel.text = model.nicename;
    self.numberLabel.text =[NSString stringWithFormat:@"编号:%@", model.user_code];
}

@end

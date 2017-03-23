//
//  JJTeacherAwardCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTeacherAwardCell.h"
#import "NSString+XPKit.h"

@interface JJTeacherAwardCell ()

@property (nonatomic, strong) UILabel *dateLabel;//时间Label
@property (nonatomic, strong) UILabel *awardCommandLabel;//作业完成不错,奖励8学币

//数量label
@property (nonatomic, strong) UILabel *coinCountLabel;
//金币ImageView
@property (nonatomic, strong) UIImageView *coinImageView;

@end

@implementation JJTeacherAwardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        //金币图片
        self.coinImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gold"]];
        [self.contentView addSubview:self.coinImageView];
        [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30 * KWIDTH_IPHONE6_SCALE);
            make.centerY.equalTo(self.contentView);
            make.right.with.offset(-37 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //金币数量
        self.coinCountLabel = [[UILabel alloc]init];
        self.coinCountLabel.font = [UIFont systemFontOfSize:13 * KWIDTH_IPHONE6_SCALE];
        self.coinCountLabel.textColor =  RGBA(124, 72, 15, 1);
        self.coinCountLabel.text = @"";
        [self.contentView addSubview:self.coinCountLabel];
        [self.coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coinImageView.mas_right).with.offset(1 * KWIDTH_IPHONE6_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        //时间Label
        UILabel *dateLabel = [[UILabel alloc]init];
        self.dateLabel = dateLabel;
        dateLabel.text = @"";
        dateLabel.textColor = RGBA(193, 92, 13, 1);
        dateLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
        [self.contentView addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(4 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(0 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //作业完成不错,奖励8学币   Label
        UILabel *awardCommandLabel = [[UILabel alloc]init];
        //    scoreCommandLabel.
        self.awardCommandLabel = awardCommandLabel;
        awardCommandLabel.font = [UIFont systemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
        awardCommandLabel.textColor = RGBA(193, 92, 13, 1);
        awardCommandLabel.numberOfLines = 0;
        [self.contentView addSubview:awardCommandLabel];
        
        [awardCommandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dateLabel.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.coinImageView.mas_left).with.offset(-5 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(5 * KWIDTH_IPHONE6_SCALE);
        }];
        awardCommandLabel.text = @"";
        
        
        
    }
    return self;
}

- (void)setModel:(JJTeacherAwardModel *)model {
    _model = model;
    self.dateLabel.text = [model.create stringChangeToDate:@"yyyy-MM-dd"];
    self.awardCommandLabel.text = model.reason;
    self.coinCountLabel.text = [NSString stringWithFormat:@"+%@",model.coin_num] ;
}
@end

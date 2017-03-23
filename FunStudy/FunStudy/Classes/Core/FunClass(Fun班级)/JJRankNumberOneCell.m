//
//  JJRankNumberOneCell.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/18.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJRankNumberOneCell.h"

@implementation JJRankNumberOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        NSLog(@"cell");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBaseView];
    }
    return self;
}
- (void)setBaseView {
    self.contentView.backgroundColor = NORMAL_COLOR;
    [self createBordersWithColor:RGBA(0, 193, 240, 1) withCornerRadius:10 andWidth:2];
    //奖杯
    self.rankImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"prizeNumberOne"]];
    [self.contentView addSubview:self.rankImageView];
    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(0);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(60 * KWIDTH_IPHONE6_SCALE);
        make.height.with.offset(60 * KWIDTH_IPHONE6_SCALE);
    }];

    //图标
    self.iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_image_new"]];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.iconImageView createBordersWithColor:[UIColor clearColor] withCornerRadius:22 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(44 * KWIDTH_IPHONE6_SCALE);
        make.left.equalTo(self.rankImageView.mas_right).with.offset(0 * KWIDTH_IPHONE6_SCALE);
    }];
    //名字
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"史文杰";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:11 * KWIDTH_IPHONE6_SCALE];
    [self.nameLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:7.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    self.nameLabel.backgroundColor = RGBA(0, 133, 220, 1);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(4 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(13 * KWIDTH_IPHONE6_SCALE);
        //        make.width.mas_equalTo(40 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(24 * KWIDTH_IPHONE6_SCALE);
    }];
    //学号
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.text = @"201210403";
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = [UIFont systemFontOfSize:11 * KWIDTH_IPHONE6_SCALE];
    [self.countLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:7.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    self.countLabel.backgroundColor = RGBA(0, 133, 220, 1);
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(4 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(13 * KWIDTH_IPHONE6_SCALE);
        make.width.equalTo(self.nameLabel.mas_width);
        make.bottom.with.offset(-24 * KWIDTH_IPHONE6_SCALE);
    }];
    //学币数量
    self.coinNumLabel = [[UILabel alloc]init];
    self.coinNumLabel.textColor = [UIColor whiteColor];
    self.coinNumLabel.text = @"  学币数量:10  ";
    [self.coinNumLabel setFont:[UIFont systemFontOfSize:14 * KWIDTH_IPHONE6_SCALE]];
    [self.contentView addSubview:self.coinNumLabel];
    [self.coinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.with.offset(-9 * KWIDTH_IPHONE6_SCALE);
        //        make.width.mas_equalTo(70 * KWIDTH_IPHONE6_SCALE);
        //        make.height.mas_equalTo(24 * KWIDTH_IPHONE6_SCALE);
    }];
}

- (void)setRankModel:(JJRankModel *)rankModel {
    _rankModel = rankModel;
    self.countLabel.text =[NSString stringWithFormat:@" %@ ", rankModel.user_code];;
    self.nameLabel.text =[NSString stringWithFormat:@" %@ ", rankModel.user_name];
    if(rankModel.isRankTopScore) {
        self.coinNumLabel.text = [NSString stringWithFormat:@"成长值:%ld",rankModel.user_coin];
    } else {
        self.coinNumLabel.text = [NSString stringWithFormat:@"学币数量:%ld",rankModel.user_coin];
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:rankModel.avatar] placeholderImage:[UIImage imageNamed:@"icon_image_new"]];
}


@end

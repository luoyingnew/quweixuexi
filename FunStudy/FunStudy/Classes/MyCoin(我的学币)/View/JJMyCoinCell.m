//
//  JJMyCoinCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyCoinCell.h"
#import "NSString+XPKit.h"

@interface JJMyCoinCell ()

//描述label
@property (nonatomic, strong) UILabel *homeWorkLabel;
//日期label
@property (nonatomic, strong) UILabel *dateLabel;
//数量label
@property (nonatomic, strong) UILabel *coinCountLabel;
//金币ImageView
@property (nonatomic, strong) UIImageView *coinImageView;

@end

@implementation JJMyCoinCell

- (void)setCoinModel:(JJMyCoinModel *)coinModel {
    _coinModel = coinModel;
    self.homeWorkLabel.text = coinModel.reason;
    self.dateLabel.text = [coinModel.createtime stringChangeToDate:@"yyyy MM dd"];
    self.coinCountLabel.text = [NSString stringWithFormat:@"+%ld",coinModel.number];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = RGBA(228, 210, 148, 1);
        //金币图片
        self.coinImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gold"]];
        [self.contentView addSubview:self.coinImageView];
        [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20 * KWIDTH_IPHONE6_SCALE);
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
        
        //描述label
        self.homeWorkLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.homeWorkLabel];
        self.homeWorkLabel.font = [UIFont systemFontOfSize:13 * KWIDTH_IPHONE6_SCALE];
        self.homeWorkLabel.text = @"";
        self.homeWorkLabel.textColor = RGBA(124, 72, 15, 1);
        self.homeWorkLabel.numberOfLines = 2;
        [self.homeWorkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.with.offset(2 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(self.coinImageView.mas_left).with.offset(-13 * KWIDTH_IPHONE6_SCALE);
        }];

        //日期Label
        self.dateLabel = [[UILabel alloc]init];
        self.dateLabel.font = [UIFont systemFontOfSize:9 * KWIDTH_IPHONE6_SCALE];
        self.dateLabel.text = @"";
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(3 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(0 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

@end

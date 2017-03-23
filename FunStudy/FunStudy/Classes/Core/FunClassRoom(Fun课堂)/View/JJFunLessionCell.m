//
//  JJFunLessionCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunLessionCell.h"

@interface JJFunLessionCell ()

@property (nonatomic, strong) UILabel *lessionNameLabel;

@end

@implementation JJFunLessionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBA(0, 207, 255, 1);
        //箭头
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FunLessionArrow"]];
        [self.contentView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-6 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(13 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(16 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //lessionLabel
        self.lessionNameLabel = [[UILabel alloc]init];
        self.lessionNameLabel.text = @"Less1";
        self.lessionNameLabel.textColor = RGBA(0, 60, 117, 1);
        self.lessionNameLabel.font = [UIFont boldSystemFontOfSize:13 * KWIDTH_IPHONE6_SCALE];
        [self.contentView addSubview:self.lessionNameLabel];
        [self.lessionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(arrowImageView.mas_left);
            make.left.with.offset(11 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

- (void)setModel:(JJFunLessionModel *)model {
    _model = model;
    self.lessionNameLabel.text = model.unit_title;
}

@end

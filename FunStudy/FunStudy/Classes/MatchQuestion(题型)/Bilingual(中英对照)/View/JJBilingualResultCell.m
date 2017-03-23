//
//  JJBilingualResultCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/20.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBilingualResultCell.h"

@interface JJBilingualResultCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *typeImageView;

@end

@implementation JJBilingualResultCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [ self createBordersWithColor:[UIColor clearColor] withCornerRadius:6 * KWIDTH_IPHONE6_SCALE andWidth:0];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = RGBA(91, 186, 241, 1);
        //boy男孩
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.text = @"";
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
        //勾或者叉
        self.typeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        [self.contentView addSubview:self.typeImageView];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.with.offset(27 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(self.typeImageView.mas_left).with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        }];
        
        self.typeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.with.offset(-22 * KWIDTH_IPHONE6_SCALE);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(18 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

- (void)setBilingualResultModel:(JJBilingualResultModel *)bilingualResultModel {
    _bilingualResultModel = bilingualResultModel;
    self.nameLabel.text = _bilingualResultModel.myAnswerleftText;
    if (_bilingualResultModel.isRight) {
        self.typeImageView.image = [UIImage imageNamed:@"MatchQuestionTrue"];
    } else {
        self.typeImageView.image = [UIImage imageNamed:@"MatchQuestionFalse"];
    }
}

@end

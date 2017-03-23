//
//  JJFollowReadResultCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFollowReadResultCell.h"

@interface JJFollowReadResultCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *typeImageView;

@end


@implementation JJFollowReadResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [ self createBordersWithColor:[UIColor clearColor] withCornerRadius:6 * KWIDTH_IPHONE6_SCALE andWidth:0];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = RGBA(91, 186, 241, 1);
        
        //播放图标
        self.typeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"readWordPlayBtn"]];
        [self.contentView addSubview:self.typeImageView];
        self.typeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.with.offset(-16 * KWIDTH_IPHONE6_SCALE);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(24 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //Hellow.boy and girls
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.text = @"";
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.with.offset(16 * KWIDTH_IPHONE6_SCALE);
            make.right.equalTo(self.typeImageView.mas_left).with.offset(-5 * KWIDTH_IPHONE6_SCALE);
        }];
        
    }
    return self;
}

- (void)setModel:(JJFollowReadModel *)model {
    _model = model;
    self.nameLabel.text = _model.topic_text;
    if([_model.topic_text hasPrefix:@"/"] && [_model.topic_text hasSuffix:@"/"]) {
        self.nameLabel.font = [UIFont fontWithName:@"YBNew.TTF" size:16 * KWIDTH_IPHONE6_SCALE];
    } else {
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
        
    }

}

@end

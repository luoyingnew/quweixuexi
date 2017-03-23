//
//  JJPlateCell.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJPlateCell.h"

@interface JJPlateCell ()

@property (nonatomic, strong) UILabel *plateNameLabel;


@end

@implementation JJPlateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createBordersWithColor:RGBA(28, 168, 255, 1) withCornerRadius:5 * KWIDTH_IPHONE6_SCALE andWidth:2 * KWIDTH_IPHONE6_SCALE];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //作业名称
        self.plateNameLabel = [[UILabel alloc]init];
        self.plateNameLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
        self.plateNameLabel.textColor = RGBA(28, 168, 255, 1);
        self.plateNameLabel.text = @"作业名";
        self.plateNameLabel.numberOfLines = 1;
        [self.contentView addSubview:self.plateNameLabel];
        [self.plateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(10 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(21 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-10 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-5 * KWIDTH_IPHONE6_SCALE);
        }];
//        //大作业联系个数
//        self.countTopicLabel = [[UILabel alloc]init];
//        self.countTopicLabel.font = [UIFont boldSystemFontOfSize:9 * KWIDTH_IPHONE6_SCALE];
//        self.countTopicLabel.textColor = RGBA(208, 208, 208, 1);
//        self.countTopicLabel.text = @"4个练习";
//        self.countTopicLabel.numberOfLines = 1;
//        [self.contentView addSubview:self.countTopicLabel];
//        [self.countTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            //            make.top.with.offset(10 * KWIDTH_IPHONE6_SCALE);
//            make.left.with.offset(21 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(16 * KWIDTH_IPHONE6_SCALE);
//            make.bottom.with.offset(-3 * KWIDTH_IPHONE6_SCALE);
//        }];
        
        
        
    }
    return self;
}


- (void)setModel:(JJPlateModel *)model {
    _model = model;
    self.plateNameLabel.text = model.plate_name;
    //self.countTopicLabel.text = [NSString stringWithFormat:@"%ld个练习",model.topics_count];
    //    self.bookNameLabel.text = model.book_title;
    //    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.book_img] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

@end

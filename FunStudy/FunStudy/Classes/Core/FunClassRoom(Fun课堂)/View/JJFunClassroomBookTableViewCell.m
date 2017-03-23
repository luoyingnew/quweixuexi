//
//  JJFunClassroomBookTableViewCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunClassroomBookTableViewCell.h"

@interface JJFunClassroomBookTableViewCell ()

//书图
@property (nonatomic, strong) UIImageView *bookImageView;
//书名
@property (nonatomic, strong) UILabel *bookNameLabel;


@end

@implementation JJFunClassroomBookTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.bookImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"defaultUserIcon"]];
        [self.contentView addSubview:self.bookImageView];
        [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(3 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-8 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(57 * KWIDTH_IPHONE6_SCALE);
        }];
        
        self.bookNameLabel = [[UILabel alloc]init];
        self.bookNameLabel.font = [UIFont boldSystemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
        self.bookNameLabel.textColor = RGBA(0, 3, 68, 1);
        self.bookNameLabel.text = @"现代新理念英语";
        self.bookNameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.bookNameLabel];
        [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(14 * KWIDTH_IPHONE6_SCALE);
            make.left.equalTo(self.bookImageView.mas_right).with.offset(16 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-16 * KWIDTH_IPHONE6_SCALE);
        }];
        
    }
    return self;
}


- (void)setModel:(JJBookModel *)model {
    _model = model;
    self.bookNameLabel.text = model.book_title;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.book_img] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}
@end

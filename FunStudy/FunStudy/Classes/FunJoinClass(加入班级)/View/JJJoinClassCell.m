//
//  JJJoinClassCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJJoinClassCell.h"

@interface JJJoinClassCell ()

@property (nonatomic, strong) UILabel *classNameLabel;
@property (nonatomic, strong) UIButton *joinClassBtn;


@end

@implementation JJJoinClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = RGBA(0, 207, 255, 1);
        //加入班级按钮
        self.joinClassBtn = [[UIButton alloc]init];
        [self.joinClassBtn addTarget:self action:@selector(joinClassBtnCLick) forControlEvents:UIControlEventTouchUpInside];
        [self.joinClassBtn setTitleColor:RGBA(183, 44, 0, 1) forState:UIControlStateNormal];
        self.joinClassBtn.titleLabel.font = [UIFont systemFontOfSize:13 *KWIDTH_IPHONE6_SCALE];
        [self.joinClassBtn setBackgroundImage:[UIImage imageNamed:@"FunClassRoomVideoBtn"] forState:UIControlStateNormal];
        [self.joinClassBtn setTitle:@"加入班级" forState:UIControlStateNormal];
        [self.contentView addSubview:self.joinClassBtn];
        [self.joinClassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-6 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(63 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(26 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //lessionLabel
        self.classNameLabel = [[UILabel alloc]init];
        self.classNameLabel.text = @"班级名称";
        self.classNameLabel.textColor = RGBA(0, 60, 117, 1);
        [self.contentView addSubview:self.classNameLabel];
        [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.joinClassBtn.mas_left);
            make.left.with.offset(11 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    return self;
}

- (void)joinClassBtnCLick {
    if(self.block) {
        self.block(self.model);
    }
}

- (void)setModel:(JJClassModel *)model {
    _model = model;
    self.classNameLabel.text = model.class_name;
}

@end

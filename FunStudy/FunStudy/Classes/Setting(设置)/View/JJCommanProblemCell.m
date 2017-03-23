//
//  JJCommanProblemCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/2.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJCommanProblemCell.h"

@interface JJCommanProblemCell ()

@property (nonatomic, strong) UILabel *questionLabel;

@end

@implementation JJCommanProblemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc]init];
        self.backView = backView;
        backView.backgroundColor = RGBA(193, 253, 251, 1);
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.contentView);
            make.left.right.equalTo(self.contentView);
            make.top.with.offset(10 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        }];
        
        self.questionLabel = [[UILabel alloc]init];
        self.questionLabel.text = @"";
        self.questionLabel.numberOfLines = 0;
        [backView addSubview:self.questionLabel];
        [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.with.offset(10 * KWIDTH_IPHONE6_SCALE);
            make.right.bottom.with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        }];
        self.questionLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
        self.questionLabel.textColor = RGBA(0, 119, 162, 1);
        [self.questionLabel sizeToFit];
    }
    return self;
}


- (void)setModel:(JJCommonProblemCellModel *)model {
    _model = model;
    if(model.isDisplay) {
        self.questionLabel.text = model.questionAndAnswer;
    } else {
        self.questionLabel.text = model.question;
    }
    
}

@end

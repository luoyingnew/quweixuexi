//
//  JJFunReadWardCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunReadWardCell.h"
#import "UIImage+XPKit.h"

@interface JJFunReadWardCell ()
//英文
@property (nonatomic, strong) UILabel *wordNameLabel;
//中文翻译
//@property (nonatomic, strong) UILabel *translateLabel;


@end

@implementation JJFunReadWardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        //背景虚线图片
//        UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SetDashed"]];
//        self.backImageView = backImageView;
//        backImageView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:backImageView];
//        backImageView.highlightedImage = [UIImage imageNamed:@"SetDashedHighlite"];
//        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.equalTo(self.contentView);
//        }];
        self.wordNameLabel = [[UILabel alloc]init];
        self.wordNameLabel.numberOfLines = 0;
        self.wordNameLabel.text = @"SPORT";
        self.wordNameLabel.font = [UIFont systemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
        self.wordNameLabel.textColor = RGBA(0, 125, 172, 1);
        [self.contentView addSubview:self.wordNameLabel];
        [self.wordNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(9 * KWIDTH_IPHONE6_SCALE);
            make.left.with.offset(13 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-9 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(16 * KWIDTH_IPHONE6_SCALE);
        }];
//        self.translateLabel = [[UILabel alloc]init];
//        self.translateLabel.text = @"";
//        self.translateLabel.font = [UIFont systemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
//        self.translateLabel.textColor = RGBA(0, 125, 172, 1);
//        [self.contentView addSubview:self.translateLabel];
//        [self.translateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.with.offset(9 * KWIDTH_IPHONE6_SCALE);
//            make.left.equalTo(self.wordNameLabel.mas_right).with.offset(5 * KWIDTH_IPHONE6_SCALE);
//            //            make.height.mas_equalTo(16 * KWIDTH_IPHONE6_SCALE);
//        }];
        self.playBtn = [[UIImageView alloc]init];
        self.playBtn.userInteractionEnabled = YES;
        self.playBtn.image = [UIImage imageNamed:@"readWordPlayBtn"];
        [self.contentView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(17 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(self.wordNameLabel.mas_bottom).with.offset(0);
            make.width.height.mas_equalTo(31 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(-4 * KWIDTH_IPHONE6_SCALE);
            
        }];
    }
    return self;
}

- (void)setModel:(JJWordModel *)model {
    _model = model;
    self.wordNameLabel.text = model.word;
//    self.translateLabel.text = model.translation;
    if(model.isDisplayChinese) {
        self.wordNameLabel.text = [NSString stringWithFormat:@"%@ %@",model.word, model.translation];
//        self.translateLabel.hidden = NO;
    } else {
        self.wordNameLabel.text = [NSString stringWithFormat:@"%@",model.word];
//        self.translateLabel.hidden = YES;
    }
    if([model.word hasPrefix:@"/"] && [model.word hasSuffix:@"/"] && model.word.length > 1) {
        self.wordNameLabel.font = [UIFont fontWithName:@"YBNew.TTF" size:15 * KWIDTH_IPHONE6_SCALE];
    } else {
        self.wordNameLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
        
    }
    
    if(!model.isPlay) {
        //9切片
//        UIImage *image = [UIImage resizableImageNamed:@"SetDashed"];
//        self.backImageView.image = [UIImage imageNamed:@"SetDashed"];
        [self.playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0 * KWIDTH_IPHONE6_SCALE);
        }];
        
    } else {
//        UIImage *image = [UIImage resizableImageNamed:@"SetDashedHighlite"];
//        self.backImageView.image = image;
//        self.backImageView.image = [UIImage imageNamed:@"SetDashedHighlite"];
        [self.playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(31 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    
}

@end

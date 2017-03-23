//
//  JJReadTestOptionalCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReadTestOptionalCell.h"
#import "UILabel+LabelStyle.h"
#import "UIFont+Common.h"

@interface JJReadTestOptionalCell ()

//单词label
@property (nonatomic, strong) UILabel *wordLabel;

@end

@implementation JJReadTestOptionalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *backV = [[UIView alloc]init];
        backV.backgroundColor = RGBA(0, 152, 206, 1);
        [backV createBordersWithColor:RGBA(0, 116, 171, 1) withCornerRadius:0 andWidth:2 * KWIDTH_IPHONE6_SCALE];
        [self.contentView addSubview:backV ];
        [backV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            make.left.with.offset(11 * KWIDTH_IPHONE6_SCALE);
        }];

        
        UIScrollView *scrollV = [[UIScrollView alloc]init];
        scrollV.backgroundColor = RGBA(0, 152, 206, 1);
//        [scrollV createBordersWithColor:RGBA(0, 116, 171, 1) withCornerRadius:0 andWidth:2 * KWIDTH_IPHONE6_SCALE];
        [backV addSubview:scrollV ];
        [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            make.left.with.offset(11 * KWIDTH_IPHONE6_SCALE);
        }];

        
        //单词
        self.wordLabel = [[UILabel alloc]init];
//        self.wordLabel.backgroundColor = RGBA(0, 152, 206, 1);
        //[self.wordLabel createBordersWithColor:RGBA(0, 116, 171, 1) withCornerRadius:0 andWidth:1 * KWIDTH_IPHONE6_SCALE];
        self.wordLabel.textAlignment = NSTextAlignmentCenter;
        self.wordLabel.numberOfLines = 0;
        [scrollV addSubview:self.wordLabel];
        self.wordLabel.textColor = [UIColor whiteColor];
        self.wordLabel.font = [UIFont boldSystemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
        [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(scrollV);
            make.width.mas_greaterThanOrEqualTo(scrollV);
            make.height.equalTo(scrollV);
        }];
        
        //字母
        self.letterLabel = [[UILabel alloc]init];
        [self.letterLabel createBordersWithColor:RGBA(0, 116, 171, 1) withCornerRadius:11 * KWIDTH_IPHONE6_SCALE andWidth:1 * KWIDTH_IPHONE6_SCALE];
        self.letterLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.letterLabel];
        self.letterLabel.backgroundColor = RGBA(0, 152, 206, 1);
        self.letterLabel.textColor = [UIColor whiteColor];
        self.letterLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
        [self.letterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(22 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(backV.mas_left);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(22 * KWIDTH_IPHONE6_SCALE);;
        }];
        
        
    }
    return self;
}

- (void)setModel:(JJSingleChooseOptionalModel *)model {
    _model = model;
    if([model.word hasPrefix:@"/"] && [model.word hasSuffix:@"/"] && model.word.length > 1) {
        self.wordLabel.font = [UIFont fontWithName:@"YBNew.TTF" size:14 * KWIDTH_IPHONE6_SCALE];
    } else {
        self.wordLabel.font = [UIFont boldSystemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
        
    }

//    self.wordLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]init];
    if(model.option_tag.length == 0) {
        [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]initWithString:model.word]];
    } else {
        NSRange range = [model.word rangeOfString:model.option_tag];
        NSString *topString = [model.word substringWithRange:NSMakeRange(0, range.location)];
        NSAttributedString *topAttributeString = [[NSAttributedString alloc]initWithString:topString];
        
        NSString *centerString = model.option_tag;
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSAttributedString *centerAttribtStr= [[NSMutableAttributedString alloc]initWithString:centerString attributes:attribtDic];
        
        NSString *bottomString = [model.word substringFromIndex:range.location + range.length];
        NSAttributedString *bottomAttributeString = [[NSAttributedString alloc]initWithString:bottomString];
        [mutableAttributedString appendAttributedString:topAttributeString];
        [mutableAttributedString appendAttributedString:centerAttribtStr];
        [mutableAttributedString appendAttributedString:bottomAttributeString];
        
    }
//    NSString *temp =nil;
//    for(int i =0; i < [model.word length]; i++)
//    {
//        temp = [model.word substringWithRange:NSMakeRange(i,1)];
//        NSMutableAttributedString *attribtStr = nil;
//        if([temp isEqualToString:model.option_tag]) {
//            //加下划线
//            NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//            attribtStr= [[NSMutableAttributedString alloc]initWithString:temp attributes:attribtDic];
//        } else {
//            //不加下划线
//            attribtStr = [[NSMutableAttributedString alloc]initWithString:temp];
//        }
//        [mutableAttributedString appendAttributedString:attribtStr];
//    }
    self.wordLabel.attributedText = mutableAttributedString;

    
//    self.wordLabel.text = model.word;
//    [self.wordLabel headIndentLength:11];
    
    self.letterLabel.text = model.letter;
    if(self.wordLabel.text.length == 0) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}


@end

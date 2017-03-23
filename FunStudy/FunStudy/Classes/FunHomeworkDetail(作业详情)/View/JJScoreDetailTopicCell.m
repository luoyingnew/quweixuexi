//
//  JJScoreDetailTopicCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJScoreDetailTopicCell.h"

@interface JJScoreDetailTopicCell ()

//听音选词
@property (nonatomic, strong)UILabel *listionAndChooseLabel;
//75分
@property (nonatomic, strong)UILabel *listionAndChooseScoreLabel;

@end

@implementation JJScoreDetailTopicCell


- (void)setModel:(JJScoreDetailTopicModel *)model {
    _model = model;
    self.listionAndChooseLabel.text = model.topic_title;
    self.listionAndChooseScoreLabel.text = model.topic_score;
    if([User getUserInformation].class_type == 1 && model.eh_type == JJFunTrackHomework) {
        //小学 并且是作业才需要隐藏
        self.listionAndChooseScoreLabel.hidden = YES;
    } else {
        //初中
        self.listionAndChooseScoreLabel.hidden = NO;
    }
}

- (void)setSecondModel:(JJScoreDetailTopicSecondModel *)secondModel {
    _secondModel = secondModel;
    self.listionAndChooseScoreLabel.text = secondModel.score__sum;
    switch (secondModel.child_type) {
        case ListenType:
            self.listionAndChooseLabel.text = @"听力题";
            break;
        case SingleChooseType:
            self.listionAndChooseLabel.text = @"单项选择";
            break;
        case ClozeProcedureType:
            self.listionAndChooseLabel.text = @"完型填空";
            break;
        case ReadType:
            self.listionAndChooseLabel.text = @"阅读理解";
            break;
        case TranslateType:
            self.listionAndChooseLabel.text = @"翻译题";
            break;
        case ErrorCorrectType:
            self.listionAndChooseLabel.text = @"改错题";
            break;
        case WriteType:
            self.listionAndChooseLabel.text = @"作文题";
            break;
        case WordSpellingType:
            self.listionAndChooseLabel.text = @"单词拼写";
            break;
        case FollowReadType:
            self.listionAndChooseLabel.text = @"跟读题";
            break;
        case ReadWordType:
            self.listionAndChooseLabel.text = @"朗读题";
            break;
        case BilingualType:
            self.listionAndChooseLabel.text = @"中英对照";
            break;
        case WordFollowReadType:
            self.listionAndChooseLabel.text = @"单词跟读";
            break;
        case WordSpellingTypeSecond:
            self.listionAndChooseLabel.text = @"单词拼写";
            break;
        case BilingualTypeSecond:
            self.listionAndChooseLabel.text = @"英汉对照";
            break;
        case ArticleFollowReadType:
            self.listionAndChooseLabel.text = @"全文跟读";
            break;
        case ArticalReadWordType:
            self.listionAndChooseLabel.text = @"全文朗读";
        default:
            break;
    }
    if([User getUserInformation].class_type == 1 ) {
        //小学
        self.listionAndChooseScoreLabel.hidden = YES;
    } else {
        //初中
        self.listionAndChooseScoreLabel.hidden = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = RGBA(228, 210, 148, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createBordersWithColor:[UIColor clearColor] withCornerRadius:3 *KWIDTH_IPHONE6_SCALE andWidth:0];
        //听音选词
        UILabel *listionAndChooseLabel = [[UILabel alloc]init];
        self.listionAndChooseLabel = listionAndChooseLabel;
        listionAndChooseLabel.text = @"听音选词";
        listionAndChooseLabel.textColor = RGBA(153, 100, 57, 1);
        listionAndChooseLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
        [self.contentView addSubview:listionAndChooseLabel];
        [listionAndChooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(13 * KWIDTH_IPHONE6_SCALE);
            make.centerY.equalTo(self.contentView);
            make.top.bottom.equalTo(self.contentView);
        }];
        //75分
        UILabel *listionAndChooseScoreLabel = [[UILabel alloc]init];
        
        self.listionAndChooseScoreLabel = listionAndChooseScoreLabel;
        listionAndChooseScoreLabel.text = @"75分";
        listionAndChooseScoreLabel.textColor = RGBA(153, 100, 57, 1);
        listionAndChooseScoreLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
        [self.contentView addSubview:listionAndChooseScoreLabel];
        [listionAndChooseScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.with.offset(-13 * KWIDTH_IPHONE6_SCALE);
            make.centerY.equalTo(self.contentView);
            make.top.bottom.equalTo(self.contentView);
        }];

        
    }
    return self;
}


@end

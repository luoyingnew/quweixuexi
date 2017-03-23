//
//  JJTopicCell.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTopicCell.h"

@interface JJTopicCell ()
//大题名称
@property (nonatomic, strong) UILabel *homeworkNameLabel;
//大题数量
@property (nonatomic, strong) UILabel *countTopicLabel;
//打勾图标
@property (nonatomic, strong) UIImageView *isOverImageView;
//是否完成Label
@property (nonatomic, strong) UILabel *isOverLabel;


@end

@implementation JJTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createBordersWithColor:RGBA(28, 168, 255, 1) withCornerRadius:5 * KWIDTH_IPHONE6_SCALE andWidth:2 * KWIDTH_IPHONE6_SCALE];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //作业名称
        self.homeworkNameLabel = [[UILabel alloc]init];
        NSLog(@"%lf",self.homeworkNameLabel.font.pointSize) ;
        self.homeworkNameLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
         NSLog(@"%lf",self.homeworkNameLabel.font.pointSize) ;
        self.homeworkNameLabel.textColor = RGBA(28, 168, 255, 1);
        self.homeworkNameLabel.text = @"作业名";
        self.homeworkNameLabel.numberOfLines = 1;
        [self.contentView addSubview:self.homeworkNameLabel];
        [self.homeworkNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(0);
            make.left.with.offset(21 * KWIDTH_IPHONE6_SCALE);
//            make.height.mas_equalTo(16 * KWIDTH_IPHONE6_SCALE);
            make.bottom.with.offset(0);
        }];
//        //大题个数
//        self.countTopicLabel = [[UILabel alloc]init];
//        self.countTopicLabel.hidden = YES;
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
        
        //是否完成Label
        self.isOverLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.isOverLabel];
        self.isOverLabel.text = @"未完成";
        self.isOverLabel.textColor = RGBA(208, 208, 208, 1);
        self.isOverLabel.font = [UIFont boldSystemFontOfSize:10 * KWIDTH_IPHONE6_SCALE];
        [self.isOverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.with.offset(-15 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //是否完成ImageView
        self.isOverImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"isOverIconNo"]];
        [self.contentView addSubview:self.isOverImageView];
        [self.isOverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.isOverLabel.mas_left).with.offset(-4 * KWIDTH_IPHONE6_SCALE);
            make.width.height.mas_equalTo(23 * KWIDTH_IPHONE6_SCALE);
        }];
        
        //遮罩
        self.shadowView = [[UIView alloc]init];
        self.shadowView.hidden = YES;
        self.shadowView.backgroundColor = RGBA(190, 190, 190, 0.5);
        [self.contentView addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setModel:(JJTopicModel *)model {
    _model = model;
    
    switch (model.type) {
        case ListenType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.听力题",model.index];
            break;
        case SingleChooseType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.单项选择",model.index] ;
            break;
        case ClozeProcedureType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.完型填空",model.index] ;
            break;
        case ReadType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.阅读理解",model.index] ;
            break;
        case TranslateType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.翻译题",model.index] ;
            break;
        case ErrorCorrectType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.改错题",model.index] ;
            break;
        case WriteType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.作文题",model.index] ;
            break;
        case WordSpellingType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.单词拼写",model.index] ;
            break;
        case FollowReadType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.跟读题",model.index] ;
            break;
        case ReadWordType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.朗读题",model.index] ;
            break;
        case BilingualType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.中英对照",model.index] ;
            break;
        case WordFollowReadType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.单词跟读",model.index] ;
            break;
        case WordSpellingTypeSecond:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.单词拼写",model.index] ;
            break;
        case BilingualTypeSecond:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.英汉对照",model.index] ;
            break;
        case ArticleFollowReadType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.全文跟读",model.index] ;
            break;
        case ArticalReadWordType:
            self.homeworkNameLabel.text =[NSString stringWithFormat:@"%ld.全文朗读",model.index] ;
            break;
        default:
            break;
    }
    
    self.isOverLabel.text = model.is_done ? @"已完成" : @"未完成";
    self.isOverLabel.textColor = model.is_done ? RGBA(243, 199, 46, 1) : [UIColor grayColor];
    self.shadowView.hidden = model.is_done ? NO : YES;
    self.userInteractionEnabled = model.is_done ? NO : YES;
    self.isOverImageView.image = [UIImage imageNamed:model.is_done? @"isOverIconYES" : @"isOverIconNo"];
    //    self.bookNameLabel.text = model.book_title;
    //    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.book_img] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end

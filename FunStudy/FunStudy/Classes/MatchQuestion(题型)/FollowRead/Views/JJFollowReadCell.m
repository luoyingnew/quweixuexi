//
//  JJFollowReadCell.m
//  FunStudy
//
//  Created by hao on 16/11/24.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFollowReadCell.h"
#import "UIImageView+JJScrollView.h"


#import <AVFoundation/AVFoundation.h>
@interface JJFollowReadCell ()


@property (nonatomic, strong) UIScrollView *homeworkContentScrollView; // 作业题内容滚动视图
@property (nonatomic, strong) UILabel *homeworkContentLabel; // 作业题内容
@property (nonatomic, strong) UIScrollView *homeworkContentTranslationScrollView; // 作业题内容-翻译滚动视图
@property (nonatomic, strong) UILabel *homeworkContentTranslationLabel; // 作业题内容-翻译
@property (nonatomic, strong) AVPlayer *player; // 播放器

@end

@implementation JJFollowReadCell

#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化视图
        [self setupView];
    }
    return self;
}

// 初始化视图
- (void)setupView {
    // 作业题背景图
    UIImageView *homeworkImageView = [[UIImageView alloc] init];
     [self.contentView addSubview:homeworkImageView];
    [homeworkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(326 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(0 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(250 * KWIDTH_IPHONE6_SCALE);
    }];
    [homeworkImageView layoutIfNeeded];
    homeworkImageView.image = [UIImage imageNamed:@"FollowReadVC_Homework_Background"];
    homeworkImageView.userInteractionEnabled = YES;
   
    
    // 进度条
    self.progressView = [[JJProgressView alloc] initWithFrame:CGRectMake(40 * KWIDTH_IPHONE6_SCALE, 27 * KWIDTH_IPHONE6_SCALE, 215 * KWIDTH_IPHONE6_SCALE, 11 * KWIDTH_IPHONE6_SCALE)];
    
    [homeworkImageView addSubview:self.progressView];
    
    // 请跟读
    UILabel *readLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(76 * KWIDTH_IPHONE6_SCALE, 50 * KWIDTH_IPHONE6_SCALE, 60*KWIDTH_IPHONE6_SCALE, 18 * KWIDTH_IPHONE6_SCALE)];
    self.readLabel = readLabel;
//    readLabel.lineBreakMode = NSLineBreakByCharWrapping;
    readLabel.font = [UIFont systemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    readLabel.textColor = [UIColor whiteColor];
    readLabel.text = self.model.topic_title;
    [homeworkImageView addSubview:readLabel];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(56 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(50 * KWIDTH_IPHONE6_SCALE);
        
    }];
    
    // 播放按钮
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton = playButton;
    playButton.frame = CGRectMake(25 * KWIDTH_IPHONE6_SCALE, 90 * KWIDTH_IPHONE6_SCALE, 35 * KWIDTH_IPHONE6_SCALE, 35 * KWIDTH_IPHONE6_SCALE);
    [playButton setBackgroundImage:[UIImage imageNamed:@"FollowRead_PlayButton"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(listenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [homeworkImageView addSubview:playButton];
    
    // 作业题
    CGFloat homeworkContentScrollViewWidth = homeworkImageView.width - playButton.right - 10 - 30; // 作业题内容控件宽度
    self.homeworkContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(playButton.right + (10 * KWIDTH_IPHONE6_SCALE), playButton.top, 190 * KWIDTH_IPHONE6_SCALE, 55 * KWIDTH_IPHONE6_SCALE)];
//    self.homeworkContentScrollView.backgroundColor = [UIColor redColor];
    [homeworkImageView addSubview:self.homeworkContentScrollView];
    self.homeworkContentScrollView.tag = noDisableVerticalScrollTag;
    
    
    // 作业题内容
    // 临时数据：作业内容
    NSString *tempHomeworkStr = @"";
    self.homeworkContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190 * KWIDTH_IPHONE6_SCALE, 0)];
//    self.homeworkContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.homeworkContentLabel.font = [UIFont systemFontOfSize:20 * KWIDTH_IPHONE6_SCALE];
    self.homeworkContentLabel.text = tempHomeworkStr;
//    self.homeworkContentLabel.backgroundColor = [UIColor greenColor];
    self.homeworkContentLabel.textColor = RGB(0, 97, 200);
    self.homeworkContentLabel.numberOfLines = 0;
    [self.homeworkContentScrollView addSubview:self.homeworkContentLabel];
    CGSize homeworkContentLabelSize = [self.homeworkContentLabel.text findHeightForHavingWidth:190 * KWIDTH_IPHONE6_SCALE andFont:self.homeworkContentLabel.font];
    self.homeworkContentLabel.size = homeworkContentLabelSize;
    self.homeworkContentScrollView.contentSize = homeworkContentLabelSize;
//    [self.homeworkContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.homeworkContentScrollView);
//        make.width.mas_equalTo(190 * KWIDTH_IPHONE6_SCALE);
//    }];
   
    
    // 作业题内容-翻译
    CGFloat homeworkContentTranslationScrollViewWidth = 160 * KWIDTH_IPHONE6_SCALE;
    self.homeworkContentTranslationScrollView = [[UIScrollView alloc] init];
    self.homeworkContentTranslationScrollView.tag = noDisableHorizontalScrollTag;
    DebugLog(@"%@",NSStringFromCGRect(self.homeworkContentTranslationScrollView.frame));
    self.homeworkContentTranslationScrollView.backgroundColor = RGB(66, 135, 224);
    self.homeworkContentTranslationScrollView.layer.cornerRadius = 5;
    self.homeworkContentTranslationScrollView.layer.masksToBounds = YES;
    [homeworkImageView addSubview:self.homeworkContentTranslationScrollView];
    [self.homeworkContentTranslationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(homeworkImageView.height - 22 * KWIDTH_IPHONE6_SCALE - 35 * KWIDTH_IPHONE6_SCALE - 5 * KWIDTH_IPHONE6_SCALE);
//        make.width.mas_equalTo(homeworkContentTranslationScrollViewWidth);
        make.height.mas_equalTo(30 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-25 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
    // 作业题内容-翻译
    NSString *tempTranslationStr = @"fjdslkjdlkj";
    self.homeworkContentTranslationLabel = [[UILabel alloc] init];
//    self.homeworkContentTranslationLabel.backgroundColor = [UIColor redColor];
    self.homeworkContentTranslationLabel.font = [UIFont systemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
    self.homeworkContentTranslationLabel.textColor = [UIColor whiteColor];
//    self.homeworkContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.homeworkContentTranslationLabel.numberOfLines = 1;
//    self.homeworkContentTranslationLabel.backgroundColor = [UIColor redColor];
    self.homeworkContentTranslationLabel.text = tempTranslationStr;
    [self.homeworkContentTranslationScrollView addSubview:self.homeworkContentTranslationLabel];
//    self.homeworkContentTranslationLabel.backgroundColor = [UIColor redColor];
    [self.homeworkContentTranslationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.homeworkContentTranslationScrollView);
        make.left.with.offset(10 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-10 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(30 * KWIDTH_IPHONE6_SCALE);

    }];
    
    
    
}

#pragma mark - 按钮点击播放
- (void)listenBtnClick {
    if(self.block) {
        self.block(self.model);
    }
}


- (void)setModel:(JJFollowReadModel *)model {
    _model = model;
    if([_model.topic_text hasPrefix:@"/"] && [_model.topic_text hasSuffix:@"/"]) {
        self.homeworkContentLabel.font = [UIFont fontWithName:@"YBNew.TTF" size:20 * KWIDTH_IPHONE6_SCALE];
    } else {
        self.homeworkContentLabel.font = [UIFont boldSystemFontOfSize:20 * KWIDTH_IPHONE6_SCALE];
    }
    
    self.homeworkContentLabel.text = model.topic_text;
    self.readLabel.text = model.topic_title;
    self.homeworkContentTranslationLabel.text = [NSString stringWithFormat:@"%@",model.translateCHinese];
//    [self.readLabel sizeToFit];
//    [self.homeworkContentLabel sizeToFit];
//    [self.homeworkContentTranslationLabel sizeToFit];
    
    CGSize homeworkContentLabelSize = [self.homeworkContentLabel.text boundingRectWithSize:CGSizeMake(190 * KWIDTH_IPHONE6_SCALE, MAXFLOAT)
                                                         options:NSStringDrawingTruncatesLastVisibleLine|
                                       NSStringDrawingUsesLineFragmentOrigin|
                                       NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:self.homeworkContentLabel.font}
                                                         context:nil].size;
    DebugLog(@"%lf %@  %@",190 * KWIDTH_IPHONE6_SCALE,NSStringFromCGSize(homeworkContentLabelSize),NSStringFromCGSize(self.homeworkContentScrollView.size));
    self.homeworkContentLabel.size = CGSizeMake(190 * KWIDTH_IPHONE6_SCALE, homeworkContentLabelSize.height) ;
    self.homeworkContentScrollView.contentSize = homeworkContentLabelSize;
    self.homeworkContentScrollView.contentOffset = CGPointMake(0, 0);
    self.homeworkContentTranslationScrollView.contentOffset = CGPointMake(0, 0);
//    [self.homeworkContentTranslationLabel headIndentLength:10 tailIndentLength:10];

}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.readLabel sizeToFit];
//    [self.homeworkContentLabel sizeToFit];
    [self.homeworkContentTranslationLabel sizeToFit];
    [self.homeworkContentScrollView layoutIfNeeded];
    [self.homeworkContentTranslationScrollView layoutIfNeeded];
//    self.homeworkContentScrollView.contentSize = [self.readLabel.text boundingRectWithSize:CGSizeMake(190 * KWIDTH_IPHONE6_SCALE, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.readLabel.font} context:nil].size;//[UILabel jj_sizeToFitWithText:self.readLabel.text Font:self.readLabel.font self.readLabel.size;
//    DebugLog(@"%@",NSStringFromCGSize(self.homeworkContentScrollView.contentSize)) ;

//    self.homeworkContentTranslationScrollView.contentSize = self.homeworkContentTranslationLabel.size;

    
    
    [self.homeworkContentScrollView flashScrollIndicators];
    [self.homeworkContentTranslationScrollView flashScrollIndicators];

    

    
//    
//    DebugLog(@"wahahahahahah%@   %@   %@   %@",NSStringFromCGSize(self.homeworkContentScrollView.contentSize),NSStringFromCGSize(self.homeworkContentScrollView.size),NSStringFromCGSize(self.homeworkContentTranslationScrollView.contentSize),NSStringFromCGSize(self.homeworkContentTranslationScrollView.size));
//    
//    if(self.homeworkContentScrollView.contentSize.height > self.homeworkContentScrollView.height) {
//        for(UIView *subView in self.homeworkContentScrollView.subviews) {
//            if([subView isKindOfClass:[UIImageView class]]) {
//                [subView setAlpha:1];
//                break;
//            }
//        }
//        [self.homeworkContentScrollView scrollRectToVisible:CGRectMake(0, 1, 190 * KWIDTH_IPHONE6_SCALE, 55 * KWIDTH_IPHONE6_SCALE) animated:YES];
//    }
//    
//    
//    if(self.homeworkContentTranslationScrollView.contentSize.width > self.homeworkContentTranslationScrollView.width) {
//        for(UIView *subView in self.homeworkContentTranslationScrollView.subviews) {
//            if([subView isKindOfClass:[UIImageView class]] && [subView isEqual:self.homeworkContentTranslationScrollView.subviews.lastObject]) {
//                [subView setAlpha:1];
//                break;
//            }
//        }
//        [self.homeworkContentTranslationScrollView scrollRectToVisible:CGRectMake(1, 0, self.homeworkContentTranslationScrollView.width, self.homeworkContentTranslationScrollView.height) animated:YES];
//    }
//    

}

@end

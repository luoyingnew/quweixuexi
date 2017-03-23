//
//  JJListenTestView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJListenTestView.h"
#import "JJSingleChooseOptionalCell.h"
#import "UILabel+LabelStyle.h"

static NSString *singleChooseOptionalCellIdentifier = @"JJsingleChooseOptionalCellIdentifier";

@interface JJListenTestView ()<UITableViewDelegate, UITableViewDataSource>

//模型
@property (nonatomic, strong) JJListenTestModel *listenTestmodel;
//当前选中的是第几个
@property(nonatomic,assign)NSInteger currentSlectedIndex;

@end

@implementation JJListenTestView

+(instancetype)listenTestViewWithListenTestModel:(JJListenTestModel *)model listenBtnClickblock:(ListenBtnClickBlock)block {
    JJListenTestView *listenTestView = [[JJListenTestView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    listenTestView.listenTestmodel = model;
    listenTestView.currentSlectedIndex = -1;
    [listenTestView setbaseView];
    if(block) {
        listenTestView.block = block;
    }
    return listenTestView;
}

- (void)setbaseView {
    //top
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SingleChooseTopBack"]];
    topImageV.userInteractionEnabled = YES;
    [self addSubview:topImageV];
    [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(328 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(243 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self);
        make.top.mas_equalTo(92 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    textLabel.textColor = RGBA(136, 0, 0, 1);
    [topImageV addSubview:textLabel];
    [textLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:9.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(33 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(19 * KWIDTH_IPHONE6_SCALE);
    }];
    //给文字拼一个喇叭
    NSTextAttachment *textAttachment01 = [[NSTextAttachment alloc] init];
    textAttachment01.image = [UIImage imageNamed: @"Match_oviduct"];  //设置图片源
    textAttachment01.bounds = CGRectMake(0, -4 * KWIDTH_IPHONE6_SCALE, 19 * KWIDTH_IPHONE6_SCALE, 19 * KWIDTH_IPHONE6_SCALE);          //设置图片位置和大小
    NSMutableAttributedString *attrStr01 = [[NSMutableAttributedString alloc] initWithString: @" 听录音,选择所听句子中包含的单词 "];
       NSAttributedString *attrStr11 = [NSAttributedString attributedStringWithAttachment: textAttachment01];
    [attrStr01 insertAttributedString: attrStr11 atIndex: 1];  //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
    textLabel.text = [NSString stringWithFormat:@" %@ ",self.listenTestmodel.topic_title];//self.listenTestmodel.topic_title;//attrStr01;
    if([self.listenTestmodel.topic_title hasPrefix:@"/"] && [self.listenTestmodel.topic_title hasSuffix:@"/"]) {
        textLabel.font = [UIFont fontWithName:@"YBNew.TTF" size:16 * KWIDTH_IPHONE6_SCALE];
    } else {
        textLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
        
    }
    
    //点击播放音频按钮
    UIButton *playBtn = [[UIButton alloc]init];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"clickPlayAudio"] forState:UIControlStateNormal];
    [topImageV addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImageV);
        make.width.mas_equalTo(72 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(76 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(61 * KWIDTH_IPHONE6_SCALE);
    }];
    [playBtn addTarget:self action:@selector(listenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //bottomTableVIew
    UIView *bottomView = [[UIView alloc]init];
    [self addSubview:bottomView];
    bottomView.backgroundColor = RGBA(255, 255, 255, 0.2);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(290 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(180 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self);
        make.top.equalTo(topImageV.mas_bottom).with.offset(20 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJSingleChooseOptionalCell class] forCellReuseIdentifier:singleChooseOptionalCellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [bottomView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(238 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(bottomView);
        make.top.with.offset(0 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(0 * KWIDTH_IPHONE6_SCALE);
    }];
    
}

#pragma mark - 按钮点击播放
- (void)listenBtnClick {
    if(self.block) {
        self.block(self.listenTestmodel);
    }
}

#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listenTestmodel.optionModelList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8 *KWIDTH_IPHONE6_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJSingleChooseOptionalCell *cell = [tableView dequeueReusableCellWithIdentifier:singleChooseOptionalCellIdentifier forIndexPath:indexPath];
    cell.model = self.listenTestmodel.optionModelList[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 26 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10 * KWIDTH_IPHONE6_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section != self.currentSlectedIndex) {
        JJSingleChooseOptionalCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSlectedIndex]];
        oldCell.letterLabel.textColor = [UIColor whiteColor];
        self.currentSlectedIndex = indexPath.section;
        self.listenTestmodel.myAnswer = self.listenTestmodel.optionModelList[self.currentSlectedIndex].letter;
        JJSingleChooseOptionalCell *currentSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
        currentSelectedCell.letterLabel.textColor = [UIColor blackColor];
    }
}


@end

//
//  JJReadTestView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReadTestView.h"
#import "JJReadTestOptionalCell.h"
#import "UILabel+LabelStyle.h"

static NSString *readTestOptionalCellIdentifier = @"JJReadTestOptionalCellIdentifier";

@interface JJReadTestView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JJReadTestProblemModel *readTestModel;
//当前选中的是第几个
@property(nonatomic,assign)NSInteger currentSlectedIndex;

@end

@implementation JJReadTestView

+(instancetype)readTestViewWithReadTestModel:(JJReadTestProblemModel *)model {
    JJReadTestView *readTestView = [[JJReadTestView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    readTestView.readTestModel = model;
    readTestView.currentSlectedIndex = -1;
    [readTestView setbaseView];
    return readTestView;
}
- (void)setbaseView {
    
    //questionLabel
    UIScrollView *questionScrollView = [[UIScrollView alloc]init];
    [self addSubview:questionScrollView];
    questionScrollView.backgroundColor = [UIColor whiteColor];
    [questionScrollView createBordersWithColor:[UIColor clearColor] withCornerRadius:17.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [questionScrollView createBordersWithColor:[UIColor clearColor] withCornerRadius:17.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [questionScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(0 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(225 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(37 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UILabel *questionLabel = [[UILabel alloc]init];
//    questionLabel.lineBreakMode = UILineBreakModeClip;
//    questionLabel.adjustsFontSizeToFitWidth = YES;
    questionLabel.numberOfLines = 0;
//    questionLabel.adjustsFontSizeToFitWidth = YES;
    questionLabel.font = [UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE];
    questionLabel.textColor = RGBA(0, 145, 182, 1);
    DebugLog(@"%@",self.readTestModel.question);
//    self.readTestModel.question = self.readTestModel.question;//@"Which of the following is true?";//[NSString stringWithFormat:@"i %@ Mountains elevent mountains now",self.readTestModel.question];
    if([@"Which " isEqualToString:@"Which "]) {
        DebugLog(@"于洋");
    }
    //后台的@"Which is NOT the good thing about the train?"
    //我的的@"Which is NOT the good thing about the train?";
    questionLabel.text = self.readTestModel.question;
    
//    CGSize textSize = [self.readTestModel.question boundingRectWithSize:CGSizeMake(195 * KWIDTH_IPHONE6_SCALE, MAXFLOAT)
//                                         options:NSStringDrawingTruncatesLastVisibleLine|
//                       NSStringDrawingUsesLineFragmentOrigin|
//                       NSStringDrawingUsesFontLeading
//                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE]}
//                                         context:nil].size;
//    CGSize textSize1 = [self.readTestModel.question boundingRectWithSize:CGSizeMake(195 * KWIDTH_IPHONE6_SCALE, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE] }
//                       context:nil].size;
//    DebugLog(@"size %@ ||size %@",NSStringFromCGSize(textSize),NSStringFromCGSize(textSize1));
//    questionLabel.frame = CGRectMake(15, 0, textSize.width, textSize.height);
//    questionScrollView.contentSize = CGSizeMake(0, textSize.height);

    
//    questionLabel.backgroundColor = [UIColor greenColor];
//    questionLabel.backgroundColor = [UIColor greenColor];
//    [questionLabel headIndentLength:15 tailIndentLength:210];
    [questionScrollView addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.with.offset(0);
        make.height.mas_greaterThanOrEqualTo(37 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(15 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-15 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(195 * KWIDTH_IPHONE6_SCALE);
        
//        make.top.with.offset(0 * KWIDTH_IPHONE6_SCALE);
//        make.centerX.equalTo(self);
//        make.width.mas_equalTo(225 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(37 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
    //bottomTableVIew
    UIView *bottomView = [[UIView alloc]init];
    [self addSubview:bottomView];
    bottomView.backgroundColor = RGBA(255, 255, 255, 0.2);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(290 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(230 * KWIDTH_IPHONE6_SCALE);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(questionScrollView.mas_bottom).with.offset(5 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJReadTestOptionalCell class] forCellReuseIdentifier:readTestOptionalCellIdentifier];
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

#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.readTestModel.optionModelList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(isPhone) {
        return 6 *KWIDTH_IPHONE6_SCALE;
    } else {
        return 3 *KWIDTH_IPHONE6_SCALE;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJReadTestOptionalCell *cell = [tableView dequeueReusableCellWithIdentifier:readTestOptionalCellIdentifier forIndexPath:indexPath];
    cell.model = self.readTestModel.optionModelList[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isPhone) {
        return 31 * KWIDTH_IPHONE6_SCALE;
    } else {
        return 25 * KWIDTH_IPHONE6_SCALE;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3 * KWIDTH_IPHONE6_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section != self.currentSlectedIndex) {
        JJReadTestOptionalCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSlectedIndex]];
        oldCell.letterLabel.textColor = [UIColor whiteColor];
        self.currentSlectedIndex = indexPath.section;
        self.readTestModel.myAnswer = self.readTestModel.optionModelList[self.currentSlectedIndex].letter;
        JJReadTestOptionalCell *currentSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
        currentSelectedCell.letterLabel.textColor = [UIColor blackColor];
    }
}
@end

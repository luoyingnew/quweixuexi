//
//  JJSingleChooseView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/20.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJSingleChooseView.h"
#import "JJSingleChooseOptionalCell.h"

static NSString *singleChooseOptionalCellIdentifier = @"JJsingleChooseOptionalCellIdentifier";

@interface JJSingleChooseView()<UITableViewDataSource, UITableViewDelegate>
//模型
@property (nonatomic, strong) JJSingleChooseModel *singleChoosemodel;
//类型
@property(nonatomic,assign)SingleChooseTestType type;

//当前选中的是第几个
@property(nonatomic,assign)NSInteger currentSlectedIndex;

@end

@implementation JJSingleChooseView

+(instancetype)singleChooseViewWithSingleChooseModel:(JJSingleChooseModel *)model{
    JJSingleChooseView *singleChooseView = [[JJSingleChooseView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    singleChooseView.singleChoosemodel = model;
    singleChooseView.type = model.type;
    singleChooseView.currentSlectedIndex = -1;
    [singleChooseView setbaseView];
    return singleChooseView;
}

- (void)setbaseView {
    //top
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SingleChooseTopBack"]];
    [self addSubview:topImageV];
    [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(328 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(243 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self);
        make.top.mas_equalTo(92 * KWIDTH_IPHONE6_SCALE);
    }];
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
    textLabel.textColor = RGBA(136, 0, 0, 1);
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.numberOfLines = 0;
    [topImageV addSubview:textLabel];
    [textLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:9.5 * KWIDTH_IPHONE6_SCALE andWidth:0];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(33 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-33 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_lessThanOrEqualTo(38 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(19 * KWIDTH_IPHONE6_SCALE);
    }];
    if(self.type == SingleChooseText) {
        //如果是选单词填空
        //请选择合适的单词
        textLabel.text = [NSString stringWithFormat:@" %@ ",self.singleChoosemodel.topic_title];//@" 请选择合适的单词 ";
        
        //问题Lable
        UILabel *questionLabel = [[UILabel alloc]init];
        questionLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
        questionLabel.textAlignment = NSTextAlignmentLeft;
        [topImageV addSubview:questionLabel];
        JJSingleChooseModel *mode = self.singleChoosemodel;
        questionLabel.numberOfLines = 0;
        questionLabel.textColor = [UIColor blackColor];
        questionLabel.text = self.singleChoosemodel.question;
        if([self.singleChoosemodel.question hasPrefix:@"/"] && [self.singleChoosemodel.question hasSuffix:@"/"]) {
            questionLabel.font = [UIFont fontWithName:@"YBNew.TTF" size:16 * KWIDTH_IPHONE6_SCALE];
        } else {
            questionLabel.font = [UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE];
        }

        
        [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(60 * KWIDTH_IPHONE6_SCALE);
            make.right.with.offset(-30 * KWIDTH_IPHONE6_SCALE);
            make.top.equalTo(textLabel.mas_bottom).with.offset(11 * KWIDTH_IPHONE6_SCALE);
            
        }];
        
    } else {
        //如果是匹配图片
//        textLabel.text = @"根据哇哈哈撒谎的就开始疯狂的说法会计师电话费会计师大回馈返回的是开发商打客服哈萨克积分哈克斯就返回时卡粉红色";//[NSString stringWithFormat:@" %@ ",self.singleChoosemodel.topic_title];;
        textLabel.text = [NSString stringWithFormat:@" %@ ",self.singleChoosemodel.topic_title];
        //图片
        UIImageView *questionImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"defaultUserIcon"]];
        [questionImageView createBordersWithColor:RGBA(46, 207, 233, 1) withCornerRadius:8 * KWIDTH_IPHONE6_SCALE andWidth:3 * KWIDTH_IPHONE6_SCALE];
        if(self.singleChoosemodel.question.length == 0) {
            questionImageView.hidden = YES;
        }
        [questionImageView sd_setImageWithURL:[NSURL URLWithString:self.singleChoosemodel.question] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
        [topImageV addSubview:questionImageView];
        [questionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(127 * KWIDTH_IPHONE6_SCALE);
            make.height.mas_equalTo(97 * KWIDTH_IPHONE6_SCALE);
            make.centerX.equalTo(topImageV);
            make.bottom.with.offset(-78 * KWIDTH_IPHONE6_SCALE);
        }];
    }
    
    
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
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
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

#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.singleChoosemodel.optionModelList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8 *KWIDTH_IPHONE6_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJSingleChooseOptionalCell *cell = [tableView dequeueReusableCellWithIdentifier:singleChooseOptionalCellIdentifier forIndexPath:indexPath];
    cell.model = self.singleChoosemodel.optionModelList[indexPath.section];
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
        self.singleChoosemodel.myAnswer = self.singleChoosemodel.optionModelList[self.currentSlectedIndex].letter;
        JJSingleChooseOptionalCell *currentSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
        currentSelectedCell.letterLabel.textColor = [UIColor blackColor];
    }
}
@end

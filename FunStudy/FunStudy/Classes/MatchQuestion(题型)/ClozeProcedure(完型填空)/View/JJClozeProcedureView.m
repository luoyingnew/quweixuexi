//
//  JJClozeProcedureView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJClozeProcedureView.h"
#import "JJReadTestOptionalCell.h"
#import "UILabel+LabelStyle.h"

static NSString *readTestOptionalCellIdentifier = @"JJReadTestOptionalCellIdentifier";

@interface JJClozeProcedureView ()<UITableViewDelegate, UITableViewDataSource>
//序号1,2,3,4,5,6,7,8
@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, strong) JJReadTestProblemModel *readTestModel;
//当前选中的是第几个(0,1,2,3)
@property(nonatomic,assign)NSInteger currentSlectedIndex;

@end

@implementation JJClozeProcedureView

+(instancetype)clozeProcedureViewWithReadTestModel:(JJReadTestProblemModel *)model {
    JJClozeProcedureView *clozeProcedureView = [[JJClozeProcedureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    clozeProcedureView.readTestModel = model;
    clozeProcedureView.currentSlectedIndex = -1;
    [clozeProcedureView setbaseView];
    return clozeProcedureView;
}
- (void)setbaseView {
    
    //bottomTableVIew
    UIView *bottomView = [[UIView alloc]init];
    [self addSubview:bottomView];
    bottomView.backgroundColor = RGBA(255, 255, 255, 0.2);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(290 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(180 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    //第几个选项
    self.indexLabel = [[UILabel alloc]init];
    [bottomView addSubview:self.indexLabel];
    self.indexLabel.font = [UIFont boldSystemFontOfSize:12 * KWIDTH_IPHONE6_SCALE];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.text = @(self.readTestModel.order).stringValue;
    self.indexLabel.textColor = RGBA(221, 0, 0, 1);
    [self.indexLabel createBordersWithColor:RGBA(221, 0, 0, 1) withCornerRadius:9.5 * KWIDTH_IPHONE6_SCALE andWidth:1* KWIDTH_IPHONE6_SCALE ];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(19 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(5 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(3 * KWIDTH_IPHONE6_SCALE);
    }];

    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJReadTestOptionalCell class] forCellReuseIdentifier:readTestOptionalCellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [bottomView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(238 * KWIDTH_IPHONE6_SCALE);
//        make.centerX.equalTo(bottomView);
        make.right.with.offset(-13 * KWIDTH_IPHONE6_SCALE);
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
    return 6 *KWIDTH_IPHONE6_SCALE;
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
    if(isPhone) {
        return 3 * KWIDTH_IPHONE6_SCALE;
    } else {
        return 2 * KWIDTH_IPHONE6_SCALE;
    }
    
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

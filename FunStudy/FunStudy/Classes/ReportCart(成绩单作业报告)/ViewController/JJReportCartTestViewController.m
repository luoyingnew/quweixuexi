//
//  JJReportCartTestViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReportCartTestViewController.h"
#import "JJReportCartCell.h"
#import "JJReportCartCellModel.h"

static NSString *const reportCartCellIdetifier = @"JJReportCartCellIdentifier";

@interface JJReportCartTestViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation JJReportCartTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationViewBg.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    //本月成绩
    UILabel *currentMonthAchievementLabel = [[UILabel alloc]init];
    [self.view addSubview:currentMonthAchievementLabel];
    currentMonthAchievementLabel.font = [UIFont systemFontOfSize:11 * KWIDTH_IPHONE6_SCALE];
    currentMonthAchievementLabel.text = @"本月成绩";
    currentMonthAchievementLabel.textColor = RGBA(186, 115, 245, 1);
    [currentMonthAchievementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(31 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(35 * KWIDTH_IPHONE6_SCALE);
        //        make.bottom.with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        //        make.right.equalTo(self.mas_right);
    }];
    //良好
    UILabel *gradeLabel = [[UILabel alloc]init];
    [self.view addSubview:gradeLabel];
    gradeLabel.font = [UIFont systemFontOfSize:27 * KWIDTH_IPHONE6_SCALE];
    gradeLabel.text = @"良好";
    gradeLabel.textColor = RGBA(250, 248, 76, 1);
    [gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.with.offset(31 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(42 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        //        make.bottom.with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        //        make.right.equalTo(self.mas_right);
    }];
    //头像
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reportCartIcon"]];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.with.offset(31 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(gradeLabel.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(75 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(76 * KWIDTH_IPHONE6_SCALE);
        //        make.bottom.with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        //        make.right.equalTo(self.mas_right);
    }];
    //作业平均成绩80分以上
    UILabel *averageGradeLabel = [[UILabel alloc]init];
    averageGradeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:averageGradeLabel];
    averageGradeLabel.backgroundColor = RGBA(0, 153, 205, 1);
    averageGradeLabel.font = [UIFont systemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
    [averageGradeLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:0];
    averageGradeLabel.text = @"作业平均成绩80分以上";
    averageGradeLabel.textColor = [UIColor whiteColor];
    [averageGradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.with.offset(31 * KWIDTH_IPHONE6_SCALE);
        make.top.equalTo(iconImageView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(187 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(20 * KWIDTH_IPHONE6_SCALE);
        
        //        make.bottom.with.offset(-14 * KWIDTH_IPHONE6_SCALE);
        //        make.right.equalTo(self.mas_right);
    }];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJReportCartCell class] forCellReuseIdentifier:reportCartCellIdetifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(253 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.top.equalTo(averageGradeLabel.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
    }];

    
}

#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;//self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7 *KWIDTH_IPHONE6_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJReportCartCell *cell = [tableView dequeueReusableCellWithIdentifier:reportCartCellIdetifier forIndexPath:indexPath];
//    cell.model = self.modelArray[indexPath.section];
    //    [cell createBordersWithColor:[UIColor clearColor] withCornerRadius:4 *KWIDTH_IPHONE6_SCALE andWidth:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 26 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

@end

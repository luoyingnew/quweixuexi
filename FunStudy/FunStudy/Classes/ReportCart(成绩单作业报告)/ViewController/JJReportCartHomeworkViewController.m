//
//  JJReportCartHomeworkViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReportCartHomeworkViewController.h"
#import "JJReportCartCell.h"
#import "JJReportCartCellModel.h"
#import "JJReportCartModel.h"
#import "JJHomeWorkDetailViewController.h"

static NSString *const reportCartCellIdetifier = @"JJReportCartCellIdentifier";

@interface JJReportCartHomeworkViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JJReportCartModel *reportCartModel;

//良好
@property (nonatomic, strong)UILabel *gradeLabel;
//作业平均成绩80分以上
@property (nonatomic, strong)UILabel *averageGradeLabel;

@end

@implementation JJReportCartHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseViewSet];
    [self requestWithDataList];
}

- (void)baseViewSet {
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
    self.gradeLabel = gradeLabel;
    [self.view addSubview:gradeLabel];
    gradeLabel.font = [UIFont systemFontOfSize:27 * KWIDTH_IPHONE6_SCALE];
    gradeLabel.text = @"";
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
    self.averageGradeLabel = averageGradeLabel;
    averageGradeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:averageGradeLabel];
    averageGradeLabel.backgroundColor = RGBA(0, 153, 205, 1);
    averageGradeLabel.font = [UIFont systemFontOfSize:14 * KWIDTH_IPHONE6_SCALE];
    [averageGradeLabel createBordersWithColor:[UIColor clearColor] withCornerRadius:10 * KWIDTH_IPHONE6_SCALE andWidth:0];
    averageGradeLabel.text = @"";
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
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJReportCartCell class] forCellReuseIdentifier:reportCartCellIdetifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(140 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(253 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.top.equalTo(averageGradeLabel.mas_bottom).with.offset(10 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 数据请求
- (void)requestWithDataList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
//        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_GRADE_REPORT];
    [JJHud showStatus:nil];
    HFURLSessionTask *task = [HFNetWork getWithURL:URL params:nil isCache:NO success:^(id response) {
        [JJHud dismiss];
//        [self.tableView.mj_header endRefreshing];
        
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            [JJHud showToast:codeMessage];
            return ;
        }
        
        self.reportCartModel = [JJReportCartModel mj_objectWithKeyValues:response[@"data"]];
        if(self.reportCartModel.score_avg.floatValue >= 90) {
            self.gradeLabel.text = @"优秀";
            self.averageGradeLabel.text = [NSString stringWithFormat:@"作业平均成绩90分以上"];
        } else if (self.reportCartModel.score_avg.floatValue >= 80){
            self.gradeLabel.text = @"良好";
            self.averageGradeLabel.text = [NSString stringWithFormat:@"作业平均成绩80分以上"];
        } else if (self.reportCartModel.score_avg.floatValue >= 60){
            self.gradeLabel.text = @"合格";
            self.averageGradeLabel.text = [NSString stringWithFormat:@"作业平均成绩60分以上"];
        } else {
            self.gradeLabel.text = @"不合格";
            self.averageGradeLabel.text = [NSString stringWithFormat:@"作业平均成绩60分以下"];
        }
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}

#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.reportCartModel.report_list.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7 *KWIDTH_IPHONE6_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJReportCartCell *cell = [tableView dequeueReusableCellWithIdentifier:reportCartCellIdetifier forIndexPath:indexPath];
    cell.model = self.reportCartModel.report_list[indexPath.section];
//    [cell createBordersWithColor:[UIColor clearColor] withCornerRadius:4 *KWIDTH_IPHONE6_SCALE andWidth:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 26 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJHomeWorkDetailViewController *homeWorkDetailViewController = [[JJHomeWorkDetailViewController alloc]init];
    homeWorkDetailViewController.homework_id = self.reportCartModel.report_list[indexPath.section].homework_id;
    [self.navigationController pushViewController:homeWorkDetailViewController animated:YES];
}
@end

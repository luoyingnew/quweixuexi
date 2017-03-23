//
//  JJFunTrackTestViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/30.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunTrackTestViewController.h"
#import "JJFunTrackHomeworkCell.h"
#import "JJFunTrackTestCell.h"
#import "UIView+JJTipNoData.h"
#import "JJFunScoreCommandViewController.h"
#import "JJHomeWorkDetailViewController.h"
#import "JJFunTrackModel.h"
#import "JJPlateViewController.h"
#import "JJTopicViewController.h"

static NSString *funTrackTestCellIdentifier = @"JJFunTrackTestCellIdentifier";

@interface JJFunTrackTestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<JJFunTrackModel *> *modelArray;

@property(nonatomic,assign)NSInteger currentPage;//当前第几页
@property(nonatomic,assign)NSInteger pageSize;//一页多少条数据

@end

@implementation JJFunTrackTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self setMjHeadFoot];
    [self.tableView registerClass:[JJFunTrackTestCell class] forCellReuseIdentifier:funTrackTestCellIdentifier];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 设置MJ头和尾
- (void)setMjHeadFoot {
    //头部下拉
    weakSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewRequestWithDataList];
    }];
    //尾部上啦
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreRequestWithDataList];
    }];
    self.currentPage = 1;
    self.pageSize = 10;
}


#pragma mark - 刷新请求
- (void)loadNewRequestWithDataList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_FOOTPRINT];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id, @"eh_type" : @2, @"page" : @(self.currentPage), @"pageSize" : @(self.pageSize)};
    [JJHud showStatus:nil];
    HFURLSessionTask *task = [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        [self.tableView.mj_header endRefreshing];
        
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
        self.currentPage = 1;
        self.modelArray = [JJFunTrackModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        //若个数小于10
        if(self.modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.tableView reloadData];
        if(self.modelArray.count == 0) {
            [self.tableView showNoDateWithTitle:@"还没有检测记录哦"];
            return;
        } else {
            [self.tableView hideNoDate];
        }
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 加载更多
- (void)loadMoreRequestWithDataList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_FOOTPRINT];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id, @"eh_type" : @2, @"page" : @(self.currentPage + 1)};
    [JJHud showStatus:nil];
    HFURLSessionTask *task = [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        [JJHud dismiss];
        [self.tableView.mj_footer endRefreshing];
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
        self.currentPage++;
        NSArray *modelArray = [JJFunTrackModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        if(modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.modelArray addObjectsFromArray:modelArray];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITAbleViewDataSource & UITableVIewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJFunTrackTestCell *cell= [tableView dequeueReusableCellWithIdentifier:funTrackTestCellIdentifier forIndexPath:indexPath ];
    cell.funTrackModel = self.modelArray[indexPath.section];
    weakSelf(weakSelf);
    cell.checkLookBlock = ^{
        JJHomeWorkDetailViewController *homeWorkVC = [[JJHomeWorkDetailViewController alloc]init];
        homeWorkVC.model = weakSelf.modelArray[indexPath.section];
        [weakSelf.navigationController pushViewController:homeWorkVC animated:YES];
    };
    cell.checkCommandBlock = ^{
        JJFunScoreCommandViewController *scoreCommandVC = [[JJFunScoreCommandViewController alloc]init];
        scoreCommandVC.scoretext = [weakSelf.modelArray[indexPath.section] teacher_comments];
        [weakSelf.navigationController pushViewController:scoreCommandVC animated:YES];
    };
    cell.continueDoHomeworkBlock = ^(NSString *typeName, NSString *homeworkTitle, NSString *homeworkID){
        [weakSelf homeworkListBtnClick:typeName homeworkTitle:homeworkTitle homeworkID:homeworkID];
    };
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}


#pragma mark - 进去最新作业,最新测验,补作业
- (void)homeworkListBtnClick:(NSString *)typeName homeworkTitle:(NSString *)homeworkTitle homeworkID:(NSString *)homeworkId{
    weakSelf(weakSelf);
    if(![typeName isEqualToString:@""]) {
        if([User getUserInformation].class_type == 1) {
            //小学
            if([typeName isEqualToString: @"最新作业"]) {
                //小学最新作业
                JJPlateViewController *plateVC = [[JJPlateViewController alloc]init];
                plateVC.name = homeworkTitle;//[User getUserInformation].last_new_homework_title;
                plateVC.typeName = @"最新作业";
                plateVC.homework_id = homeworkId;//[User getUserInformation].last_new_homeworkID;
                [self.navigationController pushViewController:plateVC animated:YES];
            }
            if([typeName isEqualToString: @"最新测验"]) {
                //小学最新测验
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新测验";//[User getUserInformation].last_new_test_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = homeworkId;//[User getUserInformation].last_new_testID;
                homeworkModel.homework_title = homeworkTitle;//[User getUserInformation].last_new_test_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
        } else {
            //初中
            if([typeName isEqualToString: @"最新作业"]) {
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新作业";//[User getUserInformation].last_new_homework_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = homeworkId;//[User getUserInformation].last_new_homeworkID;
                homeworkModel.homework_title = homeworkTitle;//[User getUserInformation].last_new_homework_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
            if([typeName isEqualToString: @"最新测验"]) {
                //初中最新测验
                JJTopicViewController *topicVC = [[JJTopicViewController alloc]init];
                //                topicVC.refeshHomeworkListBlock = ^{
                //                    [weakSelf requestWithExamList];
                //                };
                topicVC.name = @"最新测验";//[User getUserInformation].last_new_test_title;
                JJHomeWorkModel *homeworkModel = [[JJHomeWorkModel alloc]init];
                homeworkModel.homework_id = homeworkId;//[User getUserInformation].last_new_testID;
                homeworkModel.homework_title = homeworkTitle;//[User getUserInformation].last_new_test_title;
                topicVC.model = homeworkModel;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
        }
        
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
@end

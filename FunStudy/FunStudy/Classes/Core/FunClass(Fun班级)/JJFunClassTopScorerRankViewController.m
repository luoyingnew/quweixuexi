//
//  JJFunClassTopScorerRankViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJFunClassTopScorerRankViewController.h"
#import "JJRankTableViewCell.h"
#import "JJRankModel.h"
#import "JJRankNumberOneCell.h"

static NSString *const rankCellIdentifier = @"JJRankCellIdentifier";
static NSString *const rankNumberOneCellIdentifier = @"JJRankNumberOneCellIdentifier";

@interface JJFunClassTopScorerRankViewController ()

@property (nonatomic, strong) NSMutableArray<JJRankModel *> *modelArray;

@end


@implementation JJFunClassTopScorerRankViewController
- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.backgroundColor = [UIColor yellowColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[JJRankTableViewCell class] forCellReuseIdentifier:rankCellIdentifier];
    [self.tableView registerClass:[JJRankNumberOneCell class] forCellReuseIdentifier:rankNumberOneCellIdentifier];
    //头部下拉
    weakSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewRequestWithDataList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 刷新请求  有提示
- (void)loadNewRequestWithDataList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_COIN_UP_RANKING];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
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
//        self.modelArray = [JJRankModel mj_objectArrayWithKeyValuesArray:response[@"coin_up_ranking_list"]];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for(NSDictionary *dict in response[@"coin_up_ranking_list"]) {
            JJRankModel *model = [JJRankModel mj_objectWithKeyValues:dict];
            model.user_coin = [dict[@"user_coin"] integerValue];
            model.isRankTopScore = YES;
            [mutableArray addObject:model];
        }
        self.modelArray = mutableArray;
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 刷新请求  无提示
- (void)loadNewRequestNoTipWithDataList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_COIN_UP_RANKING];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
    HFURLSessionTask *task = [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
        if (![response isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        DebugLog(@"response = %@", response);
        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
        if (codeValue) { //详情数据加载失败
            NSString *codeMessage = [response objectForKey:@"error_msg"];
            DebugLog(@"codeMessage = %@", codeMessage);
            return ;
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        for(NSDictionary *dict in response[@"coin_up_ranking_list"]) {
            JJRankModel *model = [JJRankModel mj_objectWithKeyValues:dict];
            model.user_coin = [dict[@"user_coin_up"] integerValue];
            model.isRankTopScore = YES;
            [mutableArray addObject:model];
        }
        self.modelArray = mutableArray;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
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
    if(indexPath.section < 3) {
        JJRankNumberOneCell *cell= [tableView dequeueReusableCellWithIdentifier:rankNumberOneCellIdentifier forIndexPath:indexPath ];
        cell.rankModel = self.modelArray[indexPath.section];
        if(indexPath.section == 0) {
            [cell.rankImageView setImage:[UIImage imageNamed:@"prizeNumberOne"]];
        }else if(indexPath.section == 1) {
            [cell.rankImageView setImage:[UIImage imageNamed:@"prizeNumberTwo"]];
        } else {
            [cell.rankImageView setImage:[UIImage imageNamed:@"prizeNumberThree"]];
        }
        return cell;
    } else {
        JJRankTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:rankCellIdentifier forIndexPath:indexPath ];
        cell.rankModel = self.modelArray[indexPath.section];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12 * KWIDTH_IPHONE6_SCALE;
}

#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}


@end

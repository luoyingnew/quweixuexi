//
//  JJMyCoinViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJMyCoinViewController.h"
#import "JJRuleViewController.h"
#import "JJMyCoinCell.h"
#import "MJRefresh.h"
#import "JJMyCoinModel.h"

@interface JJMyCoinViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<JJMyCoinModel *> *modelArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *coinCountLabel;

@property(nonatomic,assign)NSInteger currentPage;//当前第几页
@property(nonatomic,assign)NSInteger pageSize;//一页多少条数据

//暂无学币记录label
@property (nonatomic, strong) UILabel *noCoinLabel;


@end

static NSString *myCoinCellIdentifier = @"JJMyCoinCellIdentifier";

@implementation JJMyCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];
    [self setNavigationBar];
    [self setMjHeadFoot];
    self.currentPage = 1;
    self.pageSize = 10;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 设置MJ头和尾
- (void)setMjHeadFoot {
    //头部下拉
    weakSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewRequestWithCoinData];
    }];
    //尾部上啦
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreRequestWithCoinData];
    }];
    
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    
    self.titleName = @"我的学币";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}

//设置中间视图
- (void)setUpCenter {
    //中部大背景
    UIView *centerBackView = [[UIView alloc]init];
    [self.view addSubview:centerBackView];
    [centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(87 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(321 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(452 * KWIDTH_IPHONE6_SCALE);
    }];
    centerBackView.backgroundColor = RGBA(190, 246, 255, 1);
    [centerBackView createBordersWithColor:RGBA(0, 164, 197, 1) withCornerRadius:10 andWidth:4];
    
    //中部top背景图
    UIImageView *topBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MyCoinTopViewBack"]];
    [centerBackView addSubview:topBackImageView];
    [topBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(19 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(282 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(215 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //学币个数
    UILabel *coinCountLabel = [[UILabel alloc]init];
    self.coinCountLabel = coinCountLabel;
    [topBackImageView addSubview:coinCountLabel];
    [coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBackImageView);
        make.top.with.offset(66 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(47 * KWIDTH_IPHONE6_SCALE);
    }];
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc]init];
    //个数
    NSAttributedString *attributeCount = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",[User getUserInformation].user_coin] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:70 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(255, 76, 0, 1)}];
    //学币
    NSAttributedString *attributeCoin = [[NSAttributedString alloc]initWithString:@"学币" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : NORMAL_COLOR}];
    [mutableAttributeString appendAttributedString:attributeCount];
    [mutableAttributeString appendAttributedString:attributeCoin];
    coinCountLabel.attributedText = mutableAttributeString;
    
//    //兑换奖品按钮
//    UIButton *changeAwardBtn = [[UIButton alloc]init];
//    [topBackImageView addSubview:changeAwardBtn];
//    [changeAwardBtn setBackgroundImage:[UIImage imageNamed:@"MyCoinChangeAward"] forState:UIControlStateNormal];
//    [changeAwardBtn setTitle:@"兑换奖品" forState:UIControlStateNormal];
//    [changeAwardBtn setTitleColor:RGBA(255, 76, 0, 1) forState:UIControlStateNormal];
//    [changeAwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(topBackImageView);
//        make.bottom.with.offset(-31 * KWIDTH_IPHONE6_SCALE);
//        make.width.mas_equalTo(166 * KWIDTH_IPHONE6_SCALE);
//        make.height.mas_equalTo(37 * KWIDTH_IPHONE6_SCALE);
//    }];
    
    //底部tableView背景图
    UIImageView *tableViewBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MyCoinTableViewBack"]];
    tableViewBackImageView.userInteractionEnabled = YES;
    [centerBackView addSubview:tableViewBackImageView];
    [tableViewBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBackImageView.mas_bottom).with.offset(9 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(282 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(183 * KWIDTH_IPHONE6_SCALE);
    }];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[JJMyCoinCell class] forCellReuseIdentifier:myCoinCellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableViewBackImageView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(160 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(255 * KWIDTH_IPHONE6_SCALE);
        make.center.equalTo(tableViewBackImageView);
    }];
    
}

//设置navigationbar
- (void)setNavigationBar {
    //规则按钮
    UIButton *ruleBtn = [[UIButton alloc]init];
    [self.view addSubview:ruleBtn];
    [ruleBtn setBackgroundImage:[UIImage imageNamed:@"getAwardBtn"] forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(gotoRuleVC) forControlEvents:UIControlEventTouchUpInside];
    [ruleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16 * KWIDTH_IPHONE6_SCALE]];
    [ruleBtn setTitle:@"规则" forState:UIControlStateNormal];
    [ruleBtn setTitleColor:RGBA(148, 0, 0, 1) forState:UIControlStateNormal];
    [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(28 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-25 * KWIDTH_IPHONE6_SCALE);
        make.width.with.offset(52 * KWIDTH_IPHONE6_SCALE);
        make.height.with.offset(33 * KWIDTH_IPHONE6_SCALE);
    }];
}

//前往规则页面
- (void)gotoRuleVC {
    JJRuleViewController *ruleVC = [[JJRuleViewController alloc]init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

//头部下拉刷新
- (void)loadNewRequestWithCoinData {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_COIN_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id, @"page" : @(1)};
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
        
        NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc]init];
        //个数
        NSNumber *totalNumber = response[@"total" ];
        NSAttributedString *attributeCount = [[NSAttributedString alloc]initWithString:[totalNumber stringValue] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:70 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(255, 76, 0, 1)}];
        //学币
        NSAttributedString *attributeCoin = [[NSAttributedString alloc]initWithString:@"学币" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : NORMAL_COLOR}];
        [mutableAttributeString appendAttributedString:attributeCount];
        [mutableAttributeString appendAttributedString:attributeCoin];
        self.coinCountLabel.attributedText = mutableAttributeString;
        self.modelArray = [JJMyCoinModel mj_objectArrayWithKeyValuesArray:response[@"coin_list"]];
        //若个数小于10
        if(self.modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        if(self.modelArray.count <= 0) {
            self.noCoinLabel.hidden = NO;
        } else {
            self.noCoinLabel.hidden = YES;
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

//尾部上拉加载
- (void)loadMoreRequestWithCoinData {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_COIN_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id, @"page" : @(self.currentPage + 1)};
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
        NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc]init];
        //个数
        NSNumber *totalNumber = response[@"total" ];
        NSAttributedString *attributeCount = [[NSAttributedString alloc]initWithString:[totalNumber stringValue] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:70 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : RGBA(255, 76, 0, 1)}];
        //学币
        NSAttributedString *attributeCoin = [[NSAttributedString alloc]initWithString:@"学币" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30 * KWIDTH_IPHONE6_SCALE] , NSForegroundColorAttributeName : NORMAL_COLOR}];
        [mutableAttributeString appendAttributedString:attributeCount];
        [mutableAttributeString appendAttributedString:attributeCoin];
        self.coinCountLabel.attributedText = mutableAttributeString;
        NSArray *modelArray = [JJMyCoinModel mj_objectArrayWithKeyValuesArray:response[@"coin_list"]];
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


#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7 *KWIDTH_IPHONE6_SCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJMyCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:myCoinCellIdentifier forIndexPath:indexPath];
    cell.coinModel = self.modelArray[indexPath.section];
    [cell createBordersWithColor:[UIColor clearColor] withCornerRadius:4 *KWIDTH_IPHONE6_SCALE andWidth:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * KWIDTH_IPHONE6_SCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (UILabel *)noCoinLabel {
    if(!_noCoinLabel) {
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.text = @"暂无学币记录";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = RGBA(206, 206, 206, 1);
        textLabel.font = [UIFont boldSystemFontOfSize:30 * KWIDTH_IPHONE6_SCALE];
        [self.tableView addSubview:textLabel];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.with.offset(0);
            make.height.mas_equalTo(160 * KWIDTH_IPHONE6_SCALE);
            make.width.mas_equalTo(255 * KWIDTH_IPHONE6_SCALE);
        }];
        textLabel.hidden = YES;

        _noCoinLabel = textLabel;
    }
    return _noCoinLabel;
}
@end

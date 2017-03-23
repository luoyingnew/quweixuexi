//
//  JJTeacherAwardViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/16.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTeacherAwardViewController.h"
#import "JJTeacherAwardModel.h"
#import "JJTeacherAwardCell.h"

static NSString *const TeacherAwardModelIdentifier = @"JJTeacherAwardModelIdentifier";

@interface JJTeacherAwardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<JJTeacherAwardModel *> *modelArray;

@property (nonatomic, strong) UILabel *getCoinLabel;//本学期获得8个学币


@end

@implementation JJTeacherAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self requestWithTeacherAwardList];
}

#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"老师奖励";
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"TeacherAwardBack"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(318 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(367 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(99 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //topImageView
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TeacherAwardTopBack"]];
//    topImageV.backgroundColor = [UIColor redColor];
    [centerBackImageView addSubview:topImageV];
    [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(30 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(centerBackImageView);
        make.width.mas_equalTo(280 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(105 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //本学期获得8个学币
    UILabel *getCoinLabel = [[UILabel alloc]init];
    getCoinLabel.text = @"";
    self.getCoinLabel = getCoinLabel;
    getCoinLabel.textColor = RGBA(193, 92, 13, 1);
    getCoinLabel.font = [UIFont boldSystemFontOfSize:17 * KWIDTH_IPHONE6_SCALE];
    [topImageV addSubview:getCoinLabel];
    [getCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(30 * KWIDTH_IPHONE6_SCALE);
        make.left.with.offset(20 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-55 * KWIDTH_IPHONE6_SCALE);
    }];
    
    
    //bottomImageView
    UIImageView *bottomImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TeacherAwardBottomBack"]];
    bottomImageV.userInteractionEnabled = YES;
//    bottomImageV.backgroundColor = [UIColor redColor];
    [centerBackImageView addSubview:bottomImageV];
    [bottomImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackImageView);
        make.width.mas_equalTo(285 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(183 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-27 * KWIDTH_IPHONE6_SCALE);
    }];
    
    //tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.estimatedRowHeight = 300;;
    self.tableView = tableView;
    
    [tableView registerClass:[JJTeacherAwardCell class] forCellReuseIdentifier:TeacherAwardModelIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [bottomImageV addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(24 * KWIDTH_IPHONE6_SCALE);
        make.top.with.offset(35 * KWIDTH_IPHONE6_SCALE);
        make.right.with.offset(-24 * KWIDTH_IPHONE6_SCALE);
        make.bottom.with.offset(-20 * KWIDTH_IPHONE6_SCALE);
    }];
}

#pragma mark - 老师奖励列表请求
- (void)requestWithTeacherAwardList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSString *URL =[NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_BOUNSE];
    [JJHud showStatus:nil];
    HFURLSessionTask *task = [HFNetWork getWithURL:URL params:nil isCache:NO success:^(id response) {
        [JJHud dismiss];
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
        self.getCoinLabel.text = [NSString stringWithFormat:@"本学期获得%@个学币",response[@"data"][@"coin_count"]];
        self.modelArray = [JJTeacherAwardModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"record_list"]];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];

}


#pragma mark - UITableviewDataSource&UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJTeacherAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:TeacherAwardModelIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
//    [cell createBordersWithColor:[UIColor clearColor] withCornerRadius:4 *KWIDTH_IPHONE6_SCALE andWidth:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}



@end

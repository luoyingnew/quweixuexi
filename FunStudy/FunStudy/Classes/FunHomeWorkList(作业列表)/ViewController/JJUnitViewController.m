//
//  JJUnitViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJUnitViewController.h"
#import "JJPlateViewController.h"
#import "JJUnitCell.h"
#import "JJUnitModel.h"
#import "JJPlateModel.h"
#import "JJPlateViewController.h"


static NSString *unitCellIdentifier = @"JJunitCellIdentifier";

@interface JJUnitViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//单元模型
@property (nonatomic, strong) NSArray<JJUnitModel *> *unitModelArray;

@end

@implementation JJUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseView];
    [self setUpCenter];
//    DebugLog(@"%@",self.name);
    [self requestWithUnitList];
}
#pragma mark - 基本设置
- (void)setUpBaseView{
    self.titleName = @"作业列表";//self.name;
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
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
        make.top.with.offset(100 * KWIDTH_IPHONE6_SCALE);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(330 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(440 * KWIDTH_IPHONE6_SCALE);
    }];
    centerBackView.backgroundColor = RGBA(126, 251, 252, 1);
    //    centerBackView.userInteractionEnabled = YES;
    [centerBackView createBordersWithColor:RGBA(0, 164, 197, 1) withCornerRadius:10 andWidth:4];
    
    //Book  TableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor redColor];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[JJUnitCell class] forCellReuseIdentifier:unitCellIdentifier];
    [centerBackView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerBackView);
        make.top.with.offset(56 * KWIDTH_IPHONE6_SCALE);
        make.width.mas_equalTo(275 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(340 * KWIDTH_IPHONE6_SCALE);
    }];
    
}


//#pragma mark - 单元列表请求
//- (void)requestWithHomeworkList {
//    if (![Util isNetWorkEnable]) {
//        [JJHud showToast:@"网络连接不可用"];
//        return;
//    }
//    NSString *URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_MAKE_HOMEWORK_LIST];
//    
//    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
//    [JJHud showStatus:nil];
//    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
//        [JJHud dismiss];
//        if (![response isKindOfClass:[NSDictionary class]]) {
//            return ;
//        }
//        DebugLog(@"response = %@", response);
//        NSInteger codeValue = [[response objectForKey:@"error_code"] integerValue];
//        if (codeValue) { //详情数据加载失败
//            NSString *codeMessage = [response objectForKey:@"error_msg"];
//            DebugLog(@"codeMessage = %@", codeMessage);
//            [JJHud showToast:codeMessage];
//            return ;
//        }
//        //self.homeworkModelArray = [JJHomeWorkModel mj_objectArrayWithKeyValuesArray:response[@"homework_list"]];
//        [self.tableView reloadData];
//        
//    } fail:^(NSError *error) {
//        [JJHud showToast:@"加载失败"];
//    }];
//}


#pragma mark - 单元列表请求
- (void)requestWithUnitList {
    if (![Util isNetWorkEnable]) {
        [JJHud showToast:@"网络连接不可用"];
        return;
    }
    NSString *URL = nil;
    URL = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_MAKE_HOMEWORK_LIST];
    NSDictionary *params = @{@"fun_user_id" : [User getUserInformation].fun_user_id};
    [JJHud showStatus:nil];
    [HFNetWork postWithURL:URL params:params isCache:NO success:^(id response) {
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
        self.unitModelArray = [JJUnitModel mj_objectArrayWithKeyValuesArray:response[@"homework_list"]];
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [JJHud showToast:@"加载失败"];
    }];
}



#pragma mark - UItableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.unitModelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JJUnitCell *unitCell = [tableView dequeueReusableCellWithIdentifier:unitCellIdentifier forIndexPath:indexPath];
    unitCell.model = self.unitModelArray[indexPath.section];
    return unitCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20 * KWIDTH_IPHONE6_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJPlateViewController *plateVC = [[JJPlateViewController alloc]init];
    JJUnitModel *unitModel = self.unitModelArray[indexPath.section];
    plateVC.name = unitModel.unit_title;
    plateVC.typeName = @"补作业";
    plateVC.homework_id = unitModel.homework_id;
    [self.navigationController pushViewController:plateVC animated:YES];
}
- (void)dealloc {
    DebugLog(@"f");
}

@end
